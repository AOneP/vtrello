class EditBoardForm
  include ActiveModel::Model

  validates :title, :describe, presence: true
  validates :title, length: { minimum: 25 }
  validates :describe, length: { maximum: 100 }

  attr_accessor :board, :title, :describe, :background_color, :id

  def save
    return false unless valid?
    board.update(board_params)
    true
  rescue => error
    errors.add(:base, I18n.t('common.notifications.wrong'))
    false
  end

  def board
    @board ||= Board.find(board_params[:id])
  end

  def board_params
    {
      title: title,
      describe: describe,
      background_color: background_color,
    }
  end

end
