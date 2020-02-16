require 'rails_helper'

describe ConfirmationsController do

  context 'valid params' do
    let(:user) { create(:user) }
    let(:token) { create(:token_confirmation, email: user.email) }

    before do
      allow(RegistrationUserMailer).to receive_message_chain('send_mail.deliver!') { true }
    end

    context 'GET new' do

      before { get :new, params: { token: token.value }}

      it 'redirect_to new_session_path' do
        expect(response).to redirect_to(new_session_url)
      end

      it 'returnes status OK' do
        expect(response).to have_http_status(302)
      end
    end

    context 'GET show' do

      before { get :show, params: { token: token.value }}

      it 'renders partial token_accepted' do
        expect(response).to render_template('_token_accepted')
      end

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end
    end
  end

  context 'invalid params' do
    let(:user) { create(:user) }

    context 'GET show' do
      context 'token invalid' do
        let(:token) { create(:token_confirmation, email: user.email) }

        it 'returnes partial token_invalid' do
          get :show, params: { token: token.value = 123 }
          expect(response).to render_template('_token_invalid')
        end
      end

      context 'token used' do
        let(:token) { create(:token_confirmation, email: user.email, used: true) }

        it 'returnes partial token_used' do
          get :show, params: { token: token.value }
          expect(response).to render_template('_token_used')
        end
      end

      context 'token expired' do
        let(:token) { create(:token_confirmation, email: user.email, created_at: Time.now - 2.days) }

        it 'returnes partial token_used' do
          get :show, params: { token: token.value }
          expect(response).to render_template('_token_expired')
        end
      end
    end
  end
end
