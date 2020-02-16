class Token::Invitation < Token

  validates :target_id, presence: true

  def target
    Board.find_by(id: target_id)
  end
end
