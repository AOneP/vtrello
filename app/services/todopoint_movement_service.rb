class TodopointMovementService

  def initialize(opts)
    return MoveVertically.move_up(opts['todopoint_id'], opts['list_id']) if opts['direction'].include?('up')
    return MoveVertically.move_down(opts['todopoint_id'], opts['list_id']) if opts['direction'].include?('down')

    return MoveHorizontally.new(opts).move if opts['direction'].include?('right-arrow')
    return MoveHorizontally.new(opts).move if opts['direction'].include?('left-arrow')
  end
end


class MoveVertically

  attr_accessor :todo_id, :direction

  def self.collection(list_id)
    List.find(list_id).todopoints
  end

  def self.move_up(todo_id, list_id)
    todo_which_i_want_to_move_up = collection(list_id).find(todo_id)
    if todo_which_i_want_to_move_up.position == 1
      return
    else
      todo_which_i_want_to_move_down = collection(list_id).find do |todopoint|
        todopoint.position == todo_which_i_want_to_move_up.position - 1
      end
      todo_which_i_want_to_move_up.update(position: todo_which_i_want_to_move_up.position - 1)
      todo_which_i_want_to_move_down.update(position: todo_which_i_want_to_move_down.position + 1)
    end
  end

  def self.move_down(todo_id, list_id)
    todo_which_i_want_to_move_down = collection(list_id).find(todo_id)
    if todo_which_i_want_to_move_down.position == collection(list_id).order(position: :asc).last.position
      fail 'nie da się'
      return
    end
    todo_which_i_want_to_move_up = collection(list_id).find do |todopoint|
      todopoint.position == todo_which_i_want_to_move_down.position + 1
    end

    todo_which_i_want_to_move_down.update(position: todo_which_i_want_to_move_down.position + 1)
    todo_which_i_want_to_move_up.update(position: todo_which_i_want_to_move_up.position - 1)
  end

end

class MoveHorizontally

  attr_accessor :list_id, :new_list_id, :todopoint_id

  def initialize(opts)
    @list_id = opts['list_id']
    @new_list_id = opts['new_list_id']
    @todopoint_id = opts['todopoint_id']
  end

  def move
    wrong_board_list
    below_moved_todopoint
    todopoint.update!(list_id: new_list_id, position: List.find(new_list_id).todopoints.size + 1)
  end

  def list
    @list ||= List.find(list_id)
  end

  def board
    @board ||= list.board
  end

  private

  def below_moved_todopoint
    list.todopoints.each do |todo|
      if todo.position > todopoint.position
        todo.update(position: todo.position - 1)
      else
        next
      end
    end
  end

  def wrong_board_list
    return if board.lists.ids.include?(new_list_id.to_i)
    errors.add(:base, I18n.t('todopoints.move.list_does_not_exist'))
  end

  def todopoint
    list.todopoints.find(todopoint_id)
  end
end
