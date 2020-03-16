class RegistrationUserForm
  include ActiveModel::Model

  validate :email_uniqueness
  validate :nickname_uniqueness
  validates :email, :password, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nickname, presence: true

  attr_accessor :email, :nickname, :password, :token_value

  def save
    return false unless valid?
      ActiveRecord::Base.transaction do
        User.create!(user_params)
        invitation_assigner.assign if (token_value.present? && user.present?)
        RegistrationUserMailer.send_mail(email).deliver!
      end
    true
  rescue => e
    errors.add(:base, I18n.t('common.notifications.wrong'))
    false
  end

  def success_notice
    return I18n.t('registrations.notifications.create') unless invitation_assigner.called?
    return I18n.t('registrations.notifications.invitation_create') if invitation_assigner.success?
    I18n.t("registrations.notifications.#{invitation_assigner.code}_invitation_create")
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

  def invitation_assigner
    @invitation_assigner ||= TokenInvitationUserAssigner.new(token_value, user)
  end

  def user
    @user
  end

  def user_params
    {
      email: email,
      nickname: nickname,
      password: password,
    }
  end
end
