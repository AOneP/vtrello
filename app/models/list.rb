class List < ApplicationRecord

  belongs_to :board
  has_many :todopoints, dependent: :destroy

end
