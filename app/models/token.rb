class Token < ApplicationRecord
  EXPIRATION_TIME = 60 * 60 * 24
  before_create :generate_token

  def expired?
    return true if (created_at.to_i - Time.now.to_i) > EXPIRATION_TIME
    false
  end

  private

  def generate_token
    uuid = SecureRandom.uuid
    return generate_token if Token.find_by(value: uuid).present?
    self.value = uuid
  end

end
