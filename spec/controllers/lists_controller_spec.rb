require 'rails_helper'

describe ListsController do

  context 'valid params' do
    let(:user) { create(:user) }
    let(:board) { create(:board, owner: user) }

    before { sign_in }

    context 'POST create' do
      let(:call) { post :create, params: { board_id: board.id, list: list_params }}
      let(:list_params) do
        {
          title: 'List title...',
          done: false
        }
      end

      it 'Add new list' do
        expect { call }.to change { List.count }.from(0).to(1)
      end

      context 'before call' do

        before { post :create, params: { board_id: board.id, list: list_params }}

        it 'redirect_to board_url' do
          expect(response).to redirect_to(board_url(board))
        end

        it 'returnes status redirect 302' do
          expect(response).to have_http_status(302)
        end
      end
    end

    context 'GET edit' do
      let(:list) { create(:list, board_id: board.id) }

      before { get :edit, params: { board_id: board.id, id: list.id }}

      it 'returnes http status: 200 OK' do
        expect(response).to have_http_status(200)
      end

      it 'render edit template' do
        expect(response).to render_template('edit')
      end

      it 'assigns @list' do
        expect(assigns(:list)).to eq(list)
      end
    end

    context 'PUT update' do
      let(:list) { create(:list, board_id: board.id ) }
      let(:new_list_title) { 'New list title...' }
      let(:new_done) { true }
      let(:params) do
        {
          title: new_list_title,
          done: new_done,
        }
      end

      let(:call) do
        put(:update, params: { list: params, board_id: board.id, id: list.id })
      end

      it 'updates list title' do
        expect { call }.to change { list.reload.title }.from(list.title).to(new_list_title)
      end

      it 'updates list done' do
        expect { call }.to change { list.reload.done }.from(list.done).to(new_done)
      end

      it 'redirect_to board_url' do
        expect(call).to redirect_to(board_url(board))
      end

      it 'renturnes status redirect 302' do
        expect(call).to have_http_status(302)
      end
    end

    context 'DELETE destroy' do
      let!(:list) { create(:list, board_id: board.id ) }
      let(:call) { delete :destroy, params: { board_id: board.id, id: list.id }}

      it 'redirect_to board_url' do
        expect(call).to redirect_to(board_url(board))
      end
    end
  end

  context 'invalid params' do
    let(:user) {create(:user) }
    let(:board) { create(:board, owner: user) }
    let(:list) { create(:list, board_id: board.id ) }
    let(:new_list_title) { '' }

    let(:params) do
      {
        title: new_list_title,
      }
    end

    before { sign_in(user) }

    context 'POST create' do
      let(:call) { post(:create, params: { list: params, board_id: board.id })}

      it 'redirect_to board_url' do
        expect(call).to redirect_to(board_url(board))
      end
    end

    context 'PUT update' do
      let(:call) { put(:update, params: { list: params, board_id: board.id, id: list.id })}

      it 'render edit template' do
        expect(call).to render_template('edit')
      end

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'does not change the Listt title' do
        expect { call }.not_to change { list.reload.title }
      end
    end
  end

  context 'no current_user' do
    let(:list) { create(:list, board_id: board.id) }
    let(:board) { create(:board, owner: user) }
    let(:user) { create(:user) }

    let(:call) { put(:update, params: { list: { title: 'Some title...' }, board_id: board.id, id: list.id })}

    it 'create redirect_to new_session_url' do
      post :create, params: { board_id: board.id }
      expect(response).to redirect_to(new_session_url)
    end

    it 'edit redirect_to new_session_url' do
      get :edit, params: { board_id: board.id, id: list.id }
      expect(response).to redirect_to(new_session_url)
    end

    it 'update redirect_to new_session_url' do
      expect { call }.not_to change { list.reload.title}
    end

    it 'update redirect_to new_session_url' do
      expect(call).to redirect_to(new_session_url)
    end

    it 'redirect_to new_session_url' do
      delete :destroy, params: { board_id: board.id, id: list.id }
      expect(response).to redirect_to(new_session_url)
    end
  end
end
