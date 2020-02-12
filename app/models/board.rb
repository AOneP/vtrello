class Board < ApplicationRecord

  has_many :lists, dependent: :destroy
  has_many :members
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  enum background_color: { red: 0, blue: 10, black: 20 }

end
