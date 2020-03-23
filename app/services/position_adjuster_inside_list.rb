class PositionAdjusterInsideList

  def initialize(list)
    @list = list
  end

  def collection
    @list.todopoints
  end

  def move(direction, todo_id)
    if direction == :up
      move_up(todo_id)
      true
    elsif direction == :down
      move_down(todo_id)
      true
    end
  end

  def move_up(todo_id)
    todo_which_i_want_to_move_up = collection.find(todo_id)
    if todo_which_i_want_to_move_up.position == 1
      return
    else
      todo_which_i_want_to_move_down = collection.find do |todopoint|
        todopoint.position == todo_which_i_want_to_move_up.position - 1
      end

      todo_which_i_want_to_move_up.update(position: todo_which_i_want_to_move_up.position - 1)
      todo_which_i_want_to_move_down.update(position: todo_which_i_want_to_move_down.position + 1)
    end
    true
  end

  def move_down(todo_id)
    todo_which_i_want_to_move_down = collection.find_by(id: todo_id)
    if todo_which_i_want_to_move_down.position == collection.order(position: :asc).last.position
      fail 'nie da się'
      return
    end
    todo_which_i_want_to_move_up = collection.find do |todopoint|
      todopoint.position == todo_which_i_want_to_move_down.position + 1
    end

    todo_which_i_want_to_move_down.update(position: todo_which_i_want_to_move_down.position + 1)
    todo_which_i_want_to_move_up.update(position: todo_which_i_want_to_move_up.position - 1)
  end
end
