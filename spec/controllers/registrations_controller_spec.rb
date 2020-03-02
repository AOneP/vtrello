require 'rails_helper'

describe RegistrationsController do
  context 'valid params' do
    context 'GET new' do

      before { get :new }

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'renders new template' do
        expect(response).to render_template('new')
      end
    end

    context 'POST create' do
      let(:call) { post(:create, params: { user: params })}

      let(:params) do
        {
          email: 'user@email.com',
          nickname: 'user_nickname',
          password: 'user_pass'
        }
      end

      before do
        allow(RegistrationUserMailer).to receive_message_chain('send_mail.deliver!') { true }
      end

      it 'Add new user' do
        expect { call }.to change { User.count }.from(0).to(1)
      end

      it 'redirect_to new_session_url' do
        expect(call).to redirect_to(new_session_url)
      end
    end
  end

  context 'invalid params' do
    let(:call) { post(:create, params: { user: params })}

    let(:params) do
      {
        email: 'user@email.com',
        nickname: 'user_nickname',
        password: 'user_pass'
      }
    end

    context 'email' do
      context 'not uniq' do
        let(:user) { create(:user, email: 'user@email.com') }

        it 'renders new template' do
          expect(call).to render_template('new')
        end

        it 'returnes status OK' do
          expect(call).to have_http_status(200)
        end

        it 'does not change User count' do
          expect { call }.not_to change { User.count }
        end
      end
    end

    context 'nickname' do
      context 'not uniq' do
        let(:user) { create(:user, nickname: 'user_nickname') }

        it 'renders new template' do
          expect(call).to render_template('new')
        end

        it 'returnes status OK' do
          expect(call).to have_http_status(200)
        end

        it 'does not change User count' do
          expect { call }.not_to change { User.count }
        end
      end
    end
  end
end
