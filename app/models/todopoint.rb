class Todopoint < ApplicationRecord

  has_many :comments, dependent: :destroy
  belongs_to :list

  validates :body, presence: true

end
