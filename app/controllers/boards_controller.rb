class BoardsController < ApplicationController

  def index
    @boards = Board.all
  end

  def new
    @board = Board.new
  end

  def show
    @lists = board.lists
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      redirect_to boards_path, notice: I18n.t('boards.notifications.create')
    else
      render :new
    end
  end

  def edit
    board
  end

  def update
    if board.update(board_params)
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
    params.require(:board).permit(:title, :background_color, :describe)
  end

end
