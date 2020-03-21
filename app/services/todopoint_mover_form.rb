class TodopointMoverForm
  include ActiveModel::Model

  attr_accessor :list_id, :new_list_id, :todopoint_id

  validate :wrong_board_list

  def save
    return false unless valid?
    below_moved_todopoint
    todopoint.update!(list_id: new_list_id, position: List.find(new_list_id).todopoints.size + 1)
    true
  rescue => error
    errors.add(:base, I18n.t('common.notifications.wrong'))
    false
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
