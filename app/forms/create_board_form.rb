class CreateBoardForm
  include ActiveModel::Model

  validates :title, :describe, presence: true
  validates :title, length: { maximum: 25 }
  validates :describe, length: { maximum: 100 }

  attr_accessor :title, :describe, :background_color, :current_user

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      board.save!
      board.members.create!(user: current_user)
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
      owner: current_user
    }
  end

end
