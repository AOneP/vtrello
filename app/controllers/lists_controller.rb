class ListsController < ApplicationController

  def index
    @lists = List.all
  end

  def create
    board_list = board.lists.new(list_params)
    if board_list.save
      redirect_to board_path(board), notice: I18n.t('lists.notifications.create')
    else
      redirect_to board_path(board), alert: I18n.t('common.notifications.wrong')
    end
  end

  def edit
    list
  end

  def update
    if list.update(list_params)
      redirect_to board_path(board), notice: I18n.t('lists.notifications.update')
    else
      render :edit
    end
  end

  def destroy
    if list.destroy
      redirect_to board_path(board), notice: I18n.t('lists.notifications.destroy')
    else
      redirect_to board_path(board), alert: I18n.t('common.notifications.wrong')
    end
  end

  private

  def board
    @board ||= Board.find(params[:board_id])
  end

  def list
    @list ||= board.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:title, :done)
  end

end
