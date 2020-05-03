class MoverPicker

  def self.service(todopoint, direction)
    return TodoPointMoverRight.new(todopoint) if direction == 'right'
    return TodoPointMoverLeft.new(todopoint) if direction == 'left'
    fail 'invalid direction'
  end
end
