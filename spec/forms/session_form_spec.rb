require 'rails_helper'

describe SessionForm do

  context '#save' do
    let(:user) { create(:user, confirmed_at: Time.now) }
    let(:email) { user.email }
    let(:password) { user.password }
    let(:params) do
      {
        email: email,
        password: password
      }
    end

    let(:form) { described_class.new(params) }

    context 'when provided valid attributes' do

      it 'returnes true' do
        expect(form.save).to eq(true)
      end
    end

    context 'when provided invalid attributes' do
      context 'invalid email' do
        let(:email) { 'invalid_email' }

        it 'returnes invalid email' do
          form.save
          expect(form.errors.full_messages).to include(I18n.t('registrations.notifications.wrong'))
        end
      end

      context 'invalid password' do
        let(:password) { 'invalid_password' }

        it 'returnes invalid email' do
          form.save
          expect(form.errors.full_messages).to include(I18n.t('registrations.notifications.wrong'))
        end
      end
    end

    context 'user is not confirmed' do
      let(:user) { create(:user) }
      it 'returnes user not confirmed' do
        form.save
        expect(form.errors.full_messages).to include(I18n.t('session.notifications.not_confirmed'))
      end
    end
  end
end
