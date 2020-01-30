class ListsController < ApplicationController

  def index
    @lists = List.all
  end

  def show
    list
  end

  def new
    @list = List.new
  end

  def create
    @board = Board.find(params[:board_id])
    @list = @board.lists.new(list_params)
    if @list.save
      redirect_to boards_path, notice: 'Stworzyłeś nową listę'
    else
      render :new
    end
  end

  def edit
    list
  end

  def update
    list
    if list.update(list_params)
      redirect_to boards_path, notice: 'Lista aktualizowana'
    else
      render :edit
    end
  end

  def destroy
    if list.destroy
      redirect_to lists_path, notice: 'Usunąłeś listę'
    else
      render :index
    end
  end

  private

  def list
    @list ||= List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:title, :done)
  end

end
