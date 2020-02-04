class TodopointsController < ApplicationController

  def new
    list
  end

  def create
    list_todopoint = list.todopoints.new(todopoint_params)
    if list_todopoint.save
      redirect_to board_path(list.board), notice: I18n.t('todopoints.notifications.create')
    else
      render :new
    end
  end

  def edit
    list
    todopoint
  end

  def update
    if todopoint.update(todopoint_params)
      redirect_to board_path(todopoint.list.board), notice: I18n.t('todopoints.notifications.update')
    else
      render :edit
    end
  end

  def destroy
    if todopoint.destroy
      redirect_to board_path(todopoint.list.board), notice: I18n.t('todopoints.notifications.destroy')
    else
      redirect_to board_path(todopoint.list.board), alert: I18n.t('common.notifications.wrong')
    end
  end

  private

  def list
    @list ||= List.find(params[:list_id])
  end

  def todopoint
    @todopoint ||= Todopoint.find(params[:id])
  end

  def todopoint_params
    params.require(:todopoint).permit(:body)
  end

end
