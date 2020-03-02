require 'rails_helper'

describe SessionsController do
  context 'valid params' do
    let(:user) { create(:user, confirmed_at: Time.now) }

    context 'GET new' do

      before { get :new }

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'renders template new' do
        expect(response).to render_template('new')
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

    before { post(:create, params: session_params) }

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
