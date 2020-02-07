class RegistrationUserForm
  include ActiveModel::Model

  validate :email_uniqueness
  validate :nickname_uniqueness
  validates :email, :password, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nickname, presence: true

  attr_accessor :email, :nickname, :password

  def save
    return false unless valid?
    User.create!(user_params)
    true
  rescue => e
    errors.add(:base, I18n.t('common.notifications.wrong'))
  end

  private

  def user_already_exist?
    User.find_by('lower(email) = ?', email.downcase).present?
  end

  def email_uniqueness
    return unless User.find_by('lower(email) = ?', email.downcase).present?
    errors.add(:base, I18n.t('registrations.notifications.wrong'))
  end

  def nickname_uniqueness
    return unless User.find_by('lower(nickname) = ?', nickname.downcase).present?
    errors.add(:base, I18n.t('registrations.notifications.not_uniq'))
  end

  def user_params
    {
      email: email,
      nickname: nickname,
      password: password,
    }
  end
end
