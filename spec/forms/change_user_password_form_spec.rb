require 'rails_helper'

describe ChangeUserPasswordForm do

  context '#save' do
    let(:user) { create(:user, confirmed_at: Time.now) }
    let(:password) { user.password }
    let(:new_password) { 'new_password' }
    let(:new_password_confirmation) { 'new_password' }
    let(:token_boolean) { false }
    let(:created_at) { Time.now }
    let(:token) { create(:token, email: user.email, used: token_boolean, created_at: created_at) }
    let(:params) do
      {
        password: password,
        new_password: new_password,
        new_password_confirmation: new_password_confirmation,
        token: token,
        current_user: user
      }
    end

  let(:form) { described_class.new(params) }

    context 'when provided valid attributes' do
      before { user }
      before { token }

      it 'returnes true' do
        expect(form.save).to eq(true)
      end
    end

    context 'when provided invalid attributes' do
      context 'token used' do
        before { user }
        before { token }
        let (:token_boolean) { true }

        it 'returnes token used' do
          form.save
          expect(form.errors.full_messages).to include('Token' + ' ' + I18n.t('password_change.errors.token.used'))
        end
      end

      context 'token expired' do
        before { user }
        before { token }
        let (:created_at) { Time.now + (60*60*24+1) }

        it 'returnes token expired' do
          form.save
          expect(form.errors.full_messages).to include('Token' + ' ' + I18n.t('password_change.errors.token.expired'))
        end
      end

      context 'wrong current password' do
        before { user }
        before { token }
        let (:password) { 'invalid_password' }

        it 'returnes invalid current password' do
          form.save
          expect(form.errors.full_messages).to include('Password' + ' ' + I18n.t('password_change.errors.password.old'))
        end
      end

      context 'wrong password confirmation' do
        before { user }
        before { token }
        let (:new_password) { 'invalid_password' }
        let (:new_password_confirmation) { 'invalid' }

        it 'returnes invalid password confirmation' do
          form.save
          expect(form.errors.full_messages).to include('Password' + ' ' + I18n.t('password_change.errors.password.confirmation'))
        end
      end

    end
  end
end
