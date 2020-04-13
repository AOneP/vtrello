class TodopointsController < ApplicationController

  def new
    list
  end

  def show
    todopoint
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

  # def move_todopoint
  #   @service = TodoMovementService.new(params['todopoint_id'], params['list_id'], params['new_list_id'])
  #   if params['direction'] == 'right'
  #     if @service.move_right
  #       redirect_to board_path(list.board), notice: 'OK :D'
  #     end
  #   elsif params['direction'] == 'left'
  #     if @service.move_left
  #       redirect_to board_path(list.board), notice: 'OK :D'
  #     end
  #   end
  # end

  def move_todopoint
    @service = MoverPicker.service(params)
    if @service.move
      redirect_to board_path(@service.board), notice: 'OK'
    else
      redirect_to board_path(@service.board), alert: "Can't move there"
    end
  end

  private

  def list
    @list ||= List.find(params[:list_id])
  end

  def todopoint
    @todopoint ||= list.todopoints.find(params[:id])
  end

  def todopoint_params
    params.require(:todopoint).permit(:body, :done)
  end
end
