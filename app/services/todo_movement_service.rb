class TodoMovementService

  def initialize(todo_point_id, list_id = nil, new_list_id = nil)
    @todo_point = Todopoint.find(todo_point_id)
  end

  def can_i_move_right?
    right_mover.can_i_move?
  end

  def can_i_move_left?
    left_mover.can_i_move?
  end

  def move_right
    right_mover.move
  end

  def move_left
    left_mover.move
  end

  private

  def right_mover
    @right_mover ||= TodoPointMoverRight.new(@todo_point)
  end

  def left_mover
    @left_mover ||= TodoPointMoverLeft.new(@todo_point)
  end
end


class TodoPointMoverRight

  def initialize(todo_point)
    @todo_point = todo_point
  end

  def move
    return false unless can_i_move?

    @todo_point.update(list: list_where_we_want_to_move_our_todo_point)
  end

  def can_i_move?
    !board_has_less_than_two_lists? && !todo_inside_last_list_on_the_right?
  end

  private

  def list_where_we_want_to_move_our_todo_point
    board.lists.find { |l| l.position == list.position + 1 }
  end

  def board_has_less_than_two_lists?
    board.lists.count < 2
  end

  def todo_inside_last_list_on_the_right?
    board.lists.pluck(:position).max == list.position
  end

  def list
    @list ||= @todo_point.list
  end

  def board
    @board ||= list.board
  end
end

class TodoPointMoverLeft

  def initialize(todo_point)
    @todo_point = todo_point
  end

  def move
    return false unless can_i_move?

    @todo_point.update(list: list_where_we_want_to_move_our_todo_point)
  end

  def can_i_move?
    !board_has_less_than_two_lists? && !todo_inside_last_list_on_the_left?
  end

  private

  def list_where_we_want_to_move_our_todo_point
    board.lists.find { |l| l.position == list.position - 1 }
  end

  def board_has_less_than_two_lists?
    board.lists.count < 2
  end

  def todo_inside_last_list_on_the_left?
    board.lists.pluck(:position).min == list.position
  end

  def list
    @list ||= @todo_point.list
  end

  def board
    @board ||= list.board
  end
end
