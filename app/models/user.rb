class User < ApplicationRecord

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nickname, presence: true, uniqueness: true

  def confirmed?
    confirmed_at.present?
  end

end
