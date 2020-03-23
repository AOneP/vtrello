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
      resort_todopoint_position(todopoint)
      redirect_to board_path(todopoint.list.board), notice: I18n.t('todopoints.notifications.destroy')
    else
      redirect_to board_path(todopoint.list.board), alert: I18n.t('common.notifications.wrong')
    end
  end

  def todopoint_movement_service
    if TodopointMovementService.new(params) == true
      redirect_to board_path(List.find(params['list_id']).board), notice: 'Ok'
    else
      redirect_to board_path(List.find(params['list_id']).board), alert: 'Źle'
    end
  end

  def move_vertically
    @form = PositionAdjusterInsideList.new(list)
    if @form.move(params[:direction].to_sym, params[:todopoint_id])
      redirect_to board_path(list.board, edit_mode: true), notice: "#{params[:direction]}"
    else
      redirect_to board_path(list.board, edit_mode: true), alert: "#{@form.errors.full_messages.join}"
    end
  end

  def move_horizontally
    @form = TodopointMoverForm.new(list_id: params[:list_id], new_list_id: params[:new_list_id], todopoint_id: params[:todopoint_id])
    if @form.save
      redirect_to board_path(@form.board, edit_mode: true), notice: I18n.t('todopoints.move.moved_correctly')
    else
      redirect_to board_path(@form.board, edit_mode: true), alert: "#{@form.errors.full_messages.join("\n")}"
    end
  end

  private

  def list
    @list ||= List.find(params[:list_id])
  end

  def todopoint
    @todopoint ||= list.todopoints.find(params[:id])
  end

  def resort_todopoint_position(todopoint)
    list.todopoints.each do |el|
      if el.position > todopoint.position
        el.position = el.position - 1
      end
    end
  end

  def todopoint_params
    params.require(:todopoint).permit(:body, :done).merge(position: @list.todopoints.size + 1)
  end

  def move_params
    {
      list_id: params[:list_id],
      new_list_id: params[:new_list_id],
      todopoint_id: params[:todopoint_id],
     }
  end
end
