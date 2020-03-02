require 'rails_helper'

describe ConfirmationUserEmailForm do

  let(:user) { create(:user, confirmed_at: Time.now) }
  let(:email) { user.email }
  let(:token_boolean) { false }
  let(:created_at) { Time.now }
  let(:token) { create(:token, email: email, used: token_boolean, created_at: created_at) }
  let(:params) do
    {
      token: token
    }
  end

  let(:form) { described_class.new(params) }

  context 'when provided valid attributes' do

    it 'returnes true' do
      # BEZ SKOMENOWANIA MAILERA NIE DZIAŁA!
      expect(form.save).to eq(true)
    end
  end

  context 'when provided invalid attributes' do
    context 'invalid user email' do
      let(:email) { 'invalid_email' }

      it 'returnes user does not exist' do
        expect(form.save).to eq(false)
      end
    end

    context 'invalid token nil' do
      let(:token) { nil }

      it 'returnes token as nil' do
        form.save
        expect(form.errors.full_messages).to include(('Invalid' + ' ' + I18n.t('common.notifications.wrong')))
      end
    end

    context 'invalid token used' do
      let(:token_boolean) { true }
      it 'returnes user does not exist' do
        form.save
        expect(form.errors.full_messages).to include(('Used' + ' ' + I18n.t('common.notifications.wrong')))
      end
    end

    context 'invalid token expired' do
      let(:created_at) { Time.now + 86400 + 1}
      it 'returnes token expired' do
        form.save
        expect(form.errors.full_messages).to include(('Expired' + ' ' + I18n.t('common.notifications.wrong')))
      end
    end

  end
end
