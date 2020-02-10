class BoardsController < ApplicationController

  def index
    @boards = Board.all
  end

  def new
    @board_form = CreateBoardForm.new(current_user: current_user)
  end

  def show
    @done_filter = params[:filter] == 'true'
    @lists = board.lists.includes(:todopoints)
    # @lists needs improvement: n + 1
  end

  def create
    @board_form = CreateBoardForm.new(board_params.merge(current_user: current_user))
    if @board_form.save
      redirect_to boards_path, notice: I18n.t('boards.notifications.create')
    else
      render :new
    end
  end

  def edit
    @board_form = EditBoardForm.new(board: board)
  end

  def update
    @board_form = EditBoardForm.new(board_params.merge(board: board))
    if @board_form.save
      redirect_to boards_path, notice: I18n.t('boards.notifications.update')
    else
      render :edit
    end
  end

  def destroy
    if board.destroy
      redirect_to boards_path, notice: I18n.t('boards.notifications.destroy')
    else
      redirect_to boards_path, alert: I18n.t('common.notifications.wrong')
    end
  end

  private

  def board
    @board ||= Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :describe, :background_color)
  end

end
