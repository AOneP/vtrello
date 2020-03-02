class SessionForm
  include ActiveModel::Model

  validate :credentials
  validate :user_confirmed

  attr_accessor :email, :nickname, :password

  def save
    return false unless valid?
    true
  end

  def user
    return @user if defined? @user
    @user = User.find_by('lower(email) = ?', email&.downcase)
  end

  private

  def correct_password?
    return true if user&.authenticate(password)
    false
  end

  def correct_credentials?
    user&.persisted? && correct_password?
  end

  def credentials
    return if correct_credentials?
    errors.add(:base, I18n.t('registrations.notifications.wrong'))
  end

  def user_confirmed
    if correct_credentials? && !user.confirmed?
      errors.add(:base, I18n.t('session.notifications.not_confirmed'))
    end
  end

end
