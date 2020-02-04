class ListsController < ApplicationController

  def index
    @lists = List.all
  end

  def show
    list
  end

<<<<<<< HEAD
  def create
    board
    list = board.lists.new(list_params)
    if list.save
      redirect_to board_path(board), notice: I18n.t('lists.notifications.create')
=======
  def new
    @list = List.new
  end

  def create
    list = List.create(list_params)
    if list.save
      redirect_to boards_path, notice: 'Stworzyłeś nową listę'
>>>>>>> 2231818... List CRUD
    else
      render :new
    end
  end

  def edit
<<<<<<< HEAD
    board
    @list = board.lists.find(params[:id])
  end

  def update
    board
    if list.update(list_params)
      redirect_to board_path(board), notice: I18n.t('lists.notifications.update')
=======
    list
  end

  def update
    list
    if list.update(list_params)
      redirect_to boards_path, notice: 'Lista aktualizowana'
>>>>>>> 2231818... List CRUD
    else
      render :edit
    end
  end

  def destroy
<<<<<<< HEAD
    board
    if list.destroy
      redirect_to board_path(board), notice: I18n.t('lists.notifications.destroy')
    else
      render :index
    end
=======
    if list.destroy
      redirect_to lists_path, notice: 'Usunąłeś listę'
    else
      render :index
    end 
>>>>>>> 2231818... List CRUD
  end

  private

  def list
    @list ||= List.find(params[:id])
  end

<<<<<<< HEAD
  def board
    @board ||= Board.find(params[:board_id])
  end

=======
>>>>>>> 2231818... List CRUD
  def list_params
    params.require(:list).permit(:title, :done)
  end

end
