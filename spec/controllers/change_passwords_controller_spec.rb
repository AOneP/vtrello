require 'rails_helper'

describe ChangePasswordsController do
  context 'valid params' do
    let(:user) { create(:user) }
    let(:token) { create(:token, email: user.email) }
    let(:new_password) { 'new_password' }
    let(:params) do
      {
        password: user.password,
        new_password: new_password,
        new_password_confirmation: 'new_password',
        current_user: user,
        token_value: token.value
      }
    end

    before { sign_in(user) }

    context 'POST create' do

      before do
        allow(ChangeUserPasswordMailer).to receive_message_chain('send_mail.deliver!') { true }
        post :create
      end

      it 'redirect_to boards_url' do
        expect(response).to redirect_to(boards_url)
      end
    end

    context 'GET edit' do
      it 'renders template edit' do
        get :edit, params: params
        expect(response).to render_template('edit')
      end
    end

    context 'PUT update' do

      let(:call) { put :update, params: params }

      context 'before call' do

        before { call }

        it 'redirect_to boards_url' do
          expect(response).to redirect_to(boards_url)
        end
      end

      it 'updates password' do
        expect { call }.to change { user.password_digest }
      end
    end
  end

  context 'invalid params' do
    let(:user) { create(:user) }
    let(:token) { create(:token, email: user.email) }
    let(:new_password) { 'new_password' }
    let(:user_password) { user.password }
    let(:params) do
      {
        password: user_password,
        new_password: new_password,
        new_password_confirmation: 'new_password',
        current_user: user,
        token_value: token.value
      }
    end

    before { sign_in(user) }

    context 'PUT update' do
      let(:call) { put :update, params: params }

      context 'password confirmation does not match' do
        let(:new_password) { 'another_password' }

        context 'before call' do

          before { call }

          it 'redirect_to boards_url' do
            expect(response).to redirect_to(boards_url)
          end
        end

        it 'does not change the password' do
          expect { call }.not_to change { user.password }
        end
      end

      context 'password is invalid' do
        let(:user_password) { 'wrong_pass' }

        context 'before call' do

          before { call }

          it 'redirect_to boards_url' do
            expect(response).to redirect_to(boards_url)
          end
        end

        it 'does not change the password' do
          expect { call }.not_to change { user.password }
        end
      end

      context 'token' do
        context 'token email does not match with user email' do
          let(:token) { create(:token, email: 'wrong@user.email') }

          context 'before call' do

            before { call }

            it 'redirect_to boards_url' do
              expect(response).to redirect_to(root_url)
            end
          end

          it 'does not change the password' do
            expect { call }.not_to change { user.password }
          end
        end
      end
    end
  end
end
