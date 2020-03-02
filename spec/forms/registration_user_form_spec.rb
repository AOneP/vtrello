require 'rails_helper'

describe RegistrationUserForm do

  context '#save' do
    let(:email) { 'adrian131114@interia.pl' }
    let(:password) { '1' }
    let(:nickname) { 'aaaaone' }
    let(:user_params) do
      {
        email: email,
        password: password,
        nickname: nickname,
      }
    end

    let(:form) { described_class.new(user_params) }

    context 'when provided valid attributes' do
      before do
        allow(RegistrationUserMailer).to receive_message_chain('send_mail.deliver!') { true }
      end
      it 'returnes true' do
        expect(form.save).to eq(true)
      end
    end

    context 'when mailer has problem with connection' do
      before do
        allow(RegistrationUserMailer).to receive_message_chain('send_mail.deliver!').and_raise('connection error')
      end
      # expect(form.errors.full_messages).to include(('Invalid' + ' ' + I18n.t('common.notifications.wrong')))

      it 'returnes false' do
        expect(form.save).to eq(false)
      end

      it 'does not create any user' do
        expect { form.save }.not_to change { User.count }
      end
    end
  end
end
