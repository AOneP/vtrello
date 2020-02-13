class ChangeUserPasswordForm
  include ActiveModel::Model

  attr_accessor :password, :new_password, :new_password_confirmation, :token, :current_user

  validates :password, presence: true
  validates :new_password, presence: true
  validates :new_password_confirmation, presence: true

  validate :password_confirmation_correct?
  validate :old_password_correct?
  validate :token_used?
  validate :token_expired?

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      token.update!(used: true)
      current_user.update!(password: new_password)
    end
    true
  rescue => error
    errors.add(:base, I18n.t('common.notifications.wrong'))
    false
  end

  private

  def password_confirmation_correct?
    return unless new_password != new_password_confirmation
    errors.add(:password, I18n.t('password_change.errors.password.confirmation'))
  end

  def old_password_correct?
    return if current_user.authenticate(password)
    errors.add(:password, I18n.t('password_change.errors.password.old'))
  end

  def token_used?
    return if token.nil? || !token.used?
    errors.add(:token, I18n.t('password_change.errors.token.used'))
  end

  def token_expired?
    return if token.nil? || token.used? || !token.expired?
    errors.add(:token, I18n.t('password_change.errors.token.expired'))
  end

end
