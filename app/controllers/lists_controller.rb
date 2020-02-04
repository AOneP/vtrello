class ListsController < ApplicationController

  def index
    @lists = List.all
  end

  def show
    list
  end

<<<<<<< HEAD
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

=======
>>>>>>> 53c8c4b... Syntax fix
  def create
    board
    list = board.lists.new(list_params)
    if list.save
<<<<<<< HEAD
<<<<<<< HEAD
      redirect_to boards_path, notice: 'Stworzyłeś nową listę'
>>>>>>> 2231818... List CRUD
=======
      redirect_to boards_path, notice: I18n.t('lists.notifications.create')
>>>>>>> 72a612f... Add List locales
=======
      redirect_to board_path(board), notice: I18n.t('lists.notifications.create')
>>>>>>> 53c8c4b... Syntax fix
    else
      render :new
    end
  end

  def edit
<<<<<<< HEAD
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
=======
    board
    @list = board.lists.find(params[:id])
>>>>>>> 53c8c4b... Syntax fix
  end

  def update
    board
    if list.update(list_params)
<<<<<<< HEAD
<<<<<<< HEAD
      redirect_to boards_path, notice: 'Lista aktualizowana'
>>>>>>> 2231818... List CRUD
=======
      redirect_to boards_path, notice: I18n.t('lists.notifications.update')
>>>>>>> 72a612f... Add List locales
=======
      redirect_to board_path(board), notice: I18n.t('lists.notifications.update')
>>>>>>> 53c8c4b... Syntax fix
    else
      render :edit
    end
  end

  def destroy
<<<<<<< HEAD
<<<<<<< HEAD
    board
    if list.destroy
      redirect_to board_path(board), notice: I18n.t('lists.notifications.destroy')
    else
      render :index
    end
=======
=======
    board
>>>>>>> 53c8c4b... Syntax fix
    if list.destroy
      redirect_to board_path(board), notice: I18n.t('lists.notifications.destroy')
    else
      render :index
<<<<<<< HEAD
    end 
>>>>>>> 2231818... List CRUD
=======
    end
>>>>>>> 72a612f... Add List locales
  end

  private

  def list
    @list ||= List.find(params[:id])
  end

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 53c8c4b... Syntax fix
  def board
    @board ||= Board.find(params[:board_id])
  end

<<<<<<< HEAD
=======
>>>>>>> 2231818... List CRUD
=======
>>>>>>> 53c8c4b... Syntax fix
  def list_params
    params.require(:list).permit(:title, :done)
  end

end
