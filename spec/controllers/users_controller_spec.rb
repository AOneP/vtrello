require 'rails_helper'

describe UsersController do
  context 'valid params' do
    let(:user) { create(:user, confirmed_at: Time.now) }

    before { sign_in(user) }

    context 'GET edit' do
      before { get :edit, params: { id: user.id }}

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'render edit template' do
        expect(response).to render_template('edit')
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(@user)
      end
    end

    context "PUT update" do
      let(:new_nickname) { 'New nickname...' }
      let(:params) do
        {
          nickname: new_nickname
        }
      end

      let(:call) do
        put(:update, params: { user: params, id: user.id })
      end

      it "updates user's nickname" do
        expect { call }.to change { user.reload.nickname }.from(user.nickname).to(new_nickname)
      end

      it 'returnes http status redirect 302' do
        expect(call).to have_http_status(302)
      end

      it 'redirect_to boards_url' do
        expect(call).to redirect_to(boards_url)
      end
    end
  end
end
