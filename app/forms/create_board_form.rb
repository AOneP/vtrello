class CreateBoardForm
  include ActiveModel::Model

  validates :title, :describe, presence: true
  validates :title, length: { maximum: 25 }
  validates :describe, length: { maximum: 100 }

  attr_accessor :title, :describe, :background_color, :current_user

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      board.save!(owner_id: current_user.id)
      board.members.create!(user_id: current_user.id)
    end
    true
  rescue => error
    errors.add(:base, I18n.t('common.notifications.wrong'))
    false
  end

  def board
    @board ||= Board.new(board_params)
  end

  private

  def board_params
    {
      title: title,
      describe: describe,
      background_color: background_color,
      owner_id: current_user.id
    }
  end

end
