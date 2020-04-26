class User < ApplicationRecord

  has_secure_password validations: false

  has_many :members, dependent: :destroy
  has_many :own_boards, class_name: 'Board', foreign_key: :owner_id
  has_many :boards_as_member, through: :members, source: :board

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nickname, presence: true, uniqueness: true

  def confirmed?
    confirmed_at.present?
  end
end
