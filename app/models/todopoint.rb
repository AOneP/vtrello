class Todopoint < ApplicationRecord

  has_many :comments, dependent: :destroy
  belongs_to :list

end
