class Board < ApplicationRecord

  has_many :lists, dependent: :destroy

  enum background_color: { red: 0, blue: 10, black: 20 }

end
