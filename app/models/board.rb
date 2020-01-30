class Board < ApplicationRecord
  before_create :set_default_background_color

  enum background_color: { red: 0, blue: 10, black: 20 }

  private

  def set_default_background_color
    return if background_color.present?
    self.background_color = 0
  end

end
