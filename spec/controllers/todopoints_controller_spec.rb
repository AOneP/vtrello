require 'rails_helper'

describe TodopointsController do

  context 'valid params' do
    let(:user) { create(:user) }
    let(:board) { create(:board, owner: user) }
    let(:list) { create(:list, board_id: board.id) }

    before { sign_in }

    context 'GET new' do

      before { get :new, params: { list_id: list.id }}

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'renders template new' do
        expect(response).to render_template('new')
      end
    end

    context 'GET show' do
      let(:todopoint) { create(:todopoint, list_id: list.id)}

      before { get :show, params: { list_id: list.id, id: todopoint.id }}

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'renders template show' do
        expect(response).to render_template('show')
      end

      it 'assigns @todopoint' do
        expect(assigns(:todopoint)).to eq(todopoint)
      end
    end

    context 'POST create' do
      let(:call) { post :create, params: { list_id: list.id, todopoint: params }}
      let(:params) do
        {
          body: 'Todopoint body...',
          done: false
        }
      end

      it 'Add new Todopoint' do
        expect { call }.to change { Todopoint.count }.from(0).to(1)
      end

      context 'before call' do

        before { get :create, params: { list_id: list.id, todopoint: params }}

        it 'returnes status redirect 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirect_to board_url' do
          expect(response).to redirect_to(board_url(board))
        end
      end
    end

    context 'GET edit' do
      let(:todopoint) { create(:todopoint, list_id: list.id)}

      before { get :edit, params: { list_id: list.id, id: todopoint.id }}

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'renders template edit' do
        expect(response).to render_template('edit')
      end

      it 'assigns @todopoint' do
        expect(assigns(:todopoint)).to eq(todopoint)
      end
    end

    context 'PUT update' do
      let(:todopoint) { create(:todopoint, list_id: list.id) }
      let(:new_todopoint_body) { 'New Todopoint body...' }
      let(:new_done) { true }
      let(:params) do
        {
          body: new_todopoint_body,
          done: new_done,
        }
      end

      let(:call) do
        put(:update, params: { todopoint: params, list_id: list.id, id: todopoint.id })
      end

      it 'updates List body' do
        expect { call }.to change { todopoint.reload.body }.from(todopoint.body).to(new_todopoint_body)
      end

      it 'updates List body' do
        expect { call }.to change { todopoint.reload.done }.from(todopoint.done).to(new_done)
      end

      it 'redirect_to board_url' do
        expect(call).to redirect_to(board_url(board))
      end

      it 'renturnes status redirect 302' do
        expect(call).to have_http_status(302)
      end
    end

    context 'DELETE destroy' do
      let(:user) { create(:user) }
      let(:board) { create(:board, owner: user) }
      let(:list) { create(:list, board_id: board.id) }
      let!(:todopoint) { create(:todopoint, list_id: list.id) }

      let(:call) { delete :destroy, params: { list_id: list.id, id: todopoint.id }}

      it 'destroys todopoit' do
        expect{ call }.to change { Todopoint.count }.from(1).to(0)
      end

      it 'redirect_to board_url' do
        expect(call).to redirect_to(board_url(board))
      end
    end
  end

  context 'invalid params' do
    let(:user) { create(:user) }
    let(:board) { create(:board, owner: user) }
    let(:list) { create(:list, board_id: board.id) }
    let(:todopoint) { create(:todopoint, list_id: list.id) }

    let(:params) do
      {
        body: todopoint_body,
        done: false
      }
    end

      before { sign_in }

    context 'POST create' do
      let(:call) { post :create, params: { list_id: list.id, todopoint: params }}

      context 'Todopoint body not present' do
        let(:todopoint_body) { '' }

        it 'renders new template' do
          call
          expect(response).to render_template('new')
        end

        it 'returnes status OK' do
          expect(response).to have_http_status(200)
        end

        it 'does not change Todopoint count' do
          expect { call }.not_to change { Todopoint.count }
        end
      end
    end

    context 'PUT update' do
      let(:call) { put :update, params: { list_id: list.id, todopoint: params, id: todopoint.id }}

      context 'Todopoint body not present' do
        let(:todopoint_body) { '' }

        context 'before call' do

          before { call }

          it 'renders edt template' do
            expect(response).to render_template('edit')
          end

          it 'does not change Todopoint count' do
            expect { call }.not_to change { Todopoint.count }
          end
        end

        it 'returnes status OK' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  context 'no current_user' do
    let(:user) { create(:user) }
    let(:board) { create(:board, owner: user) }
    let(:list) { create(:list, board_id: board.id) }
    let(:todopoint) { create(:todopoint, list_id: list.id) }

    it 'new redirect_to new_session_url' do
      get :new, params: { list_id: list.id }
      expect(response).to redirect_to(new_session_url)
    end

    it 'show redirect_to new_session_url' do
      get :show, params: { list_id: list.id, id: todopoint.id }
      expect(response).to redirect_to(new_session_url)
    end

    it 'create redirect_to new_session_url' do
      post :create, params: { list_id: list.id }
      expect(response).to redirect_to(new_session_url)
    end

    it 'edit redirect_to new_session_url' do
      get :edit, params: { list_id: list.id, id: todopoint.id }
      expect(response).to redirect_to(new_session_url)
    end

    it 'update redirect_to new_session_url' do
      put :update, params: { list_id: list.id, id: todopoint.id }
      expect(response).to redirect_to(new_session_url)
    end

    it 'destroy redirect_to new_session_url' do
      delete :destroy, params: { list_id: list.id, id: todopoint.id }
      expect(response).to redirect_to(new_session_url)
    end
  end
end
