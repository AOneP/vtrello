class List < ApplicationRecord

  has_many :todopoints, dependent: :destroy
  belongs_to :board

  validates :title, presence: true

end
