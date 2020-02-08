class ConfirmationUserEmailForm
  include ActiveModel::Model

  validate :validate_token

  attr_accessor :token

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      user.update!(confirmed_at: Time.now)
      token.update!(used: true)
    end
    true
  rescue
    errors.add(:base, I18n.t('confirmations.notifications.wrong'))
    false
  end

  def error_partial
    partial_name[errors.keys.first]
  end

  private

  def token_nil?
    return unless token.nil?
    errors.add(:invalid, I18n.t('common.notifications.wrong'))
  end

  def token_used?
    return unless token.used?
    errors.add(:used, I18n.t('common.notifications.wrong'))
  end

  def token_expired?
    return unless token.expired?
    errors.add(:expired, I18n.t('common.notifications.wrong'))
  end

  def validate_token
    return if !token_nil? && !token_used? && !token_expired?
    errors.add(:base, I18n.t('confirmations.notifications.token'))
  end

  def partial_name
    {
      used: 'token_used',
      invalid: 'token_invalid',
      expired: 'token_expired',
    }
  end

  def user
    @user ||= User.find_by!(email: token&.email)
  end

end
