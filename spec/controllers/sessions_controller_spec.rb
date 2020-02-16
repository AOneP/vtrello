require 'rails_helper'

describe SessionsController do
  context 'valid params' do
    let(:user) { create(:user, confirmed_at: Time.now) }

    context 'GET new' do


      context 'when not logged in' do

        before { get :new }

        it 'returnes status OK' do
          expect(response).to have_http_status(200)
        end

        it 'renders template new' do
          expect(response).to render_template('new')
        end
      end

      context 'when logged in with' do
        let(:token) { create(:token_invitation, email: current_user.email, value: '123', target_id: board.id) }
        let(:board) { create(:board, owner: user)}
        let(:call) { get :new, params: { token: token.value } }
        let(:current_user) { create(:user, confirmed_at: Time.now) }

        context 'valid token' do

          before do
            sign_in(current_user)
          end

          it 'creates member' do
            expect { call }.to change { Member.count }.by(1)
          end

          it 'changes token used flag' do
            expect { call }.to change { token.reload.used }.from(false).to(true)
          end

          it 'returnes message added_to_board' do
            call
            expect(flash[:notice]).to eq(I18n.t('member_invitation.notifications.success'))
          end
        end

        context 'invalid token' do
          context 'already used' do

            before do
              token.update(used: true)
              sign_in(current_user)
            end

            it 'does not create member' do
              expect { call }.not_to change { Member.count }
            end

            it 'does not change token used flag' do
              expect { call }.not_to change { token.reload.used }
            end

            it 'returnes message used' do
              call
              expect(flash[:alert]).to eq(I18n.t('application.notifications.board_invitations.used'))
            end
          end

          context 'already expired' do

            before do
              token.update(created_at: Time.now - 2.days)
              sign_in(current_user)
            end

            it 'does not create member' do
              expect { call }.not_to change { Member.count }
            end

            it 'does not change token used flag' do
              expect { call }.not_to change { token.reload.used }
            end

            it 'returnes message expired' do
              call
              expect(flash[:alert]).to eq(I18n.t('application.notifications.board_invitations.expired'))
            end
          end

          context 'invalid current_user' do
            before do
              token.update(email: 'another@email.com')
              sign_in(current_user)
            end

            it 'does not create member' do
              expect { call }.not_to change { Member.count }
            end

            it 'does not change token used flag' do
              expect { call }.not_to change { token.reload.used }
            end

            it 'returnes message invalid_current_user' do
              call
              expect(flash[:alert]).to eq(I18n.t('application.notifications.board_invitations.invalid_current_user'))
            end
          end
        end
      end

      context 'when logged in without token' do

        before do
          sign_in
          get :new
        end

        it 'redirect_to boards_path' do
          expect(response).to redirect_to(boards_url)
        end

        it 'returnes already_logged message' do
          expect(flash[:notice]).to eq(I18n.t('session.notifications.already_logged'))
        end

        it 'returnes status 302' do
          expect(response).to have_http_status(302)
        end
      end
    end

    context 'POST create' do
      let(:session_params) do
        {
          email: user.email,
          nickname: user.nickname,
          password: user.password
        }
      end

      let(:call) { post(:create, params: session_params) }

      context 'before call' do

        before { call }

        it 'redirect_to boards_path' do
          expect(response).to redirect_to(boards_url)
        end
      end

      it 'Add new session' do
        expect { call }.to change { session[:id] }.from(nil).to(user.id)
      end
    end
  end

  context 'DELETE destroy' do
    let(:user) { create(:user, confirmed_at: Time.now) }
    let(:call) { delete :destroy, params: { id: session[:id] } }

    let(:session_params) do
      {
        email: user.email,
        nickname: user.nickname,
        password: user.password
      }
    end

    before { session[:id] = user.id }

    it 'redirect_to new_session_path' do
      expect(call).to redirect_to(new_session_url)
    end

    it 'delete session' do
      expect { call }.to change { session[:id] }.from(user.id).to(nil)
    end
  end

  context 'invalid params' do
    let(:user) { create(:user, confirmed_at: Time.now) }
    let(:session_params) do
      {
        email: user.email,
        nickname: user.nickname,
        password: user.password
      }
    end
    let(:call) { post :create, params: session_params }


    context 'POST create' do
      context 'email does not exist' do

        it 'renders new template' do
          expect_any_instance_of(SessionForm).to receive(:save) { false }
          call
        end
      end
    end
  end
end
