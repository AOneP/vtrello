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
    list = List.new(list_params)
    if list.save
      redirect_to boards_path, notice: I18n.t('lists.notifications.create')
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
      redirect_to boards_path, notice: I18n.t('lists.notifications.update')
    else
      render :edit
    end
  end

  def destroy
    if list.destroy
      redirect_to lists_path, notice: I18n.t('lists.notifications.destroy')
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
