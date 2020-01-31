class BoardsController < ApplicationController

  def index
    @boards = Board.all
  end

  def new
    @board = Board.new
  end

  def show
    board
    @list = board.lists.new
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      redirect_to boards_path, notice: 'Stworzyłeś nowy board!'
    else
      render :new
    end
  end

  def edit
    board
  end

  def update
    if board.update(board_params)
      redirect_to boards_path, notice: 'Board aktualizowany'
    else
      render :edit
    end
  end

  def destroy
    if board.destroy
      redirect_to boards_path, notice: 'Usunąłeś board!'
    else
      redirect_to boards_path, alert: 'Coś poszło źle!'
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
