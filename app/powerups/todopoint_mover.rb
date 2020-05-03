module TodopointMover

  delegate :can_i_move_left?, :can_i_move_right?, to: :mover_service

  private

  def mover_service
    @mover_service ||= TodoMovementService.new(id)
  end
end
