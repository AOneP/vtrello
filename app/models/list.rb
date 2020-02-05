class List < ApplicationRecord

  has_many :todopoints, dependent: :destroy
  belongs_to :board

end
