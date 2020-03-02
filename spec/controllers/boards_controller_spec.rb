require 'rails_helper'

describe BoardsController do
  context 'valid params' do
    let(:user) { create(:user) }

    before { sign_in }

    context 'GET index' do
      let(:board) { create(:board, owner: user) }

      before { get :index }

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'renders index template' do
        expect(response).to render_template('index')
      end

      it 'assigns @boards' do
        expect(assigns(:boards)).to eq([board])
      end
    end

    context 'GET new' do

      before { get :new }

      it 'renders new template' do
        expect(response).to render_template('new')
      end

      it 'renturnes status OK' do
        expect(response).to have_http_status(200)
      end
    end

    context 'GET show' do

      let(:board) { create(:board, owner: user)}
      before { get :show, params: { id: board.id } }

      it 'renders show template' do
        expect(response).to render_template('show')
      end

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @board' do
        expect(assigns(:board)).to eq(board)
      end
    end

    context 'POST create' do
      let(:call) { post(:create, params: { board: params })}

      let(:params) do
        {
          title: 'Board title...',
          describe: 'Board describe...',
          background_color: 'black',
          owner: user
        }
      end

      it 'Add new board' do
        expect { call }.to change { Board.count }.from(0).to(1)
      end

      context 'before call' do

        before { get :create, params: { board: params }}

        it 'redirect to boards_path' do
          expect(response).to redirect_to(boards_url)
        end

        it 'returnes status redirect 302' do
          expect(response).to have_http_status(302)
        end
      end
    end

    context 'GET edit' do
      let(:board) { create(:board, owner: user)}

      before { get :edit, params: { id: board.id }}

      it 'returnes status OK' do
        expect(response).to have_http_status(200)
      end

      it 'renderse edit template' do
        expect(response).to render_template('edit')
      end

      it 'assigns @boards' do
        expect(assigns(:board)).to eq(board)
      end
    end

    context 'PUT update' do
      let(:board) { create(:board, owner: user) }
      let(:new_board_title) { 'Board new title...' }
      let(:new_board_describe) { 'Board new describe...' }
      let(:new_background_color) { 'red' } # NIE POWINIEN BYĆ INTEGER?
      let(:params) do
        {
          title: new_board_title,
          describe: new_board_describe,
          background_color: new_background_color,
        }
      end

      let(:call) do
        put(:update, params: { board: params, id: board.id })
      end

      it 'changes board title' do
        expect { call }.to change { board.reload.title }.from(board.title).to(new_board_title)
      end

      it 'changes board describe' do
        expect { call }.to change { board.reload.describe }.from(board.describe).to(new_board_describe)
      end

      it 'changes board background_color' do
        expect { call }.to change { board.reload.background_color }.from(board.background_color).to(new_background_color)
      end

      it 'returnes status redirect 302' do
        put :update, params: { board: params, id: board.id }
        expect(response).to have_http_status(302)
      end

      it 'redirect_to boards_path_url' do
        put :update, params: { board: params, id: board.id }
        expect(response).to redirect_to(boards_url)
      end
    end

    context 'DELETE destroy' do
      let!(:board) { create(:board, owner: user) }
      let(:call) { delete :destroy, params: { id: board.id }}

      it 'destroys board' do
        expect{ call }.to change { Board.count }.from(1).to(0)
      end

      it 'redirect_to boards_url' do
        expect(call).to redirect_to(boards_url)
      end
    end
  end

  context 'invalid params' do
    let(:user) { create(:user) }
    let(:board) { create(:board, owner: user) }
    let(:board_title) { board.title }
    let(:board_describe) { board.describe }
    let(:board_background_color) { board.background_color }

    let(:params) do
      {
        title: board_title,
        describe: board_describe,
        background_color: board_background_color,
      }
    end

    before { sign_in(user) }

    context 'POST create' do
      let(:call) { post :create, params: { board: params, owner: user }}

      context 'board title too long' do
        let(:board_title) { 'Definietly this title is too long' }

        it 'renders new template' do
          call
          expect(response).to render_template('new')
        end

        it 'returnes false for CreateBoardForm' do
          expect_any_instance_of(CreateBoardForm).to receive(:save).once
          call
        end

        it 'returnes status OK' do
          expect(response).to have_http_status(200)
        end

        it 'does not change Board count' do
          call
          expect { call }.not_to change { Board.count }
        end
      end

      context 'board describe empty' do
        let(:board_describe) { '' }

        context 'before call' do

          before { call }

          it 'renders new template' do
            expect(response).to render_template('new')
          end

          it 'does not change Board count' do
            expect { call }.not_to change { Board.count }
          end
        end

        it 'returnes status OK' do
          expect(response).to have_http_status(200)
        end
      end

      context 'wrong background_color' do
        let(:board_background_color) { 'yellow' }

        it 'renders new template' do
          call
          expect(response).to render_template('new')
        end

        it 'returnes status OK' do
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'PUT update' do
      let(:call) { put :update, params: { board: params, id: board.id }}

      context 'board title too long' do
        let(:board_title) { 'Definietly this title is too long' }

        it 'renders edit template' do
          expect(call).to render_template('edit')
        end

        it 'does not change Board title' do
          expect { call }.not_to change { board.reload.title }
        end

        it 'returnes status OK' do
          expect(response).to have_http_status(200)
        end
      end

      context 'board describe empty' do
        let(:board_describe) { '' }

        it 'renders edit template' do
          expect(call).to render_template('edit')
        end

        it 'does not change Board describe' do
          expect { call }.not_to change { board.reload.describe }
        end

        it 'returnes status OK' do
          expect(response).to have_http_status(200)
        end
      end

      context 'wrong background_color' do
        let(:board_background_color) { 'yellow' }

        it 'renders edit template' do
          expect(call).to render_template('edit')
        end

        it 'does not change background_color' do
          expect { call }.not_to change { board.reload.background_color }
        end

        it 'returnes status OK' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  context 'no current_user' do
    let(:board) { create(:board, owner: user) }
    let(:user) { create(:user) }

    context 'Actions without current_user' do

      it 'index redirect_to new_session_url' do
        get :index
        expect(response).to redirect_to(new_session_url)
      end

      it 'new redirect_to new_session_url' do
        get :new
        expect(response).to redirect_to(new_session_url)
      end

      it 'show redirect_to new_session_url' do
        get :show, params: { id: board.id }
        expect(response).to redirect_to(new_session_url)
      end

      it 'create redirect_to new_session_url' do
        post :create
        expect(response).to redirect_to(new_session_url)
      end

      it 'edit redirect_to new_session_url' do
        get :edit, params: { id: board.id }
        expect(response).to redirect_to(new_session_url)
      end

      it 'update redirect_to new_session_url' do
        put :update, params: { id: board.id }
        expect(response).to redirect_to(new_session_url)
      end

      it 'destroy redirect_to new_session_url' do
        delete :destroy, params: { id: board.id }
        expect(response).to redirect_to(new_session_url)
      end
    end
  end
end
