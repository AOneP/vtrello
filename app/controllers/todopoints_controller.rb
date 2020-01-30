class TodopointsController < ApplicationController

  def index
    @todopoints = Todopoint.all
  end

  def show
    todopoint
  end

  def new
    @todopoint = Todopoint.new
  end

  def create
    todopoint = Todopoint.new(todopoint_params)
    if todopoint.save
      redirect_to todopoints_path, notice: 'Stworzyłeś Todopoint'
    else
      render :new
    end
  end

  def edit
    todopoint
  end

  def update
    todopoint
    if todopoint.update(todopoint_params)
      redirect_to lists_path, notice: 'Aktualizowałeś Todopoint'
    else
      render :edit
    end
  end

  def destroy
    if todopoint.destroy
      redirect_to todopoints_path, notice: 'Usunąłeś todopoint'
    else
      render :index
    end
  end

  private

  def todopoint
    @todopoint ||= Todopoint.find(params[:id])
  end

  def todopoint_params
    params.require(:todopoint).permit(:title, :todo_type, :done)
  end
  
end
