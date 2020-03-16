class SessionForm
  include ActiveModel::Model

  validate :credentials
  validate :user_confirmed

  attr_accessor :email, :nickname, :password, :token_value

  def save
    return false unless valid?
    invitation_assigner.assign if (token_value.present? && user.present?)
    true
  rescue => e
    errors.add(:base, I18n.t('common.notifications.wrong'))
    false
  end

  def user
    return @user if defined? @user
    @user = User.find_by('lower(email) = ?', email&.downcase)
  end

  def success_notice
    return I18n.t('session.notifications.create') unless invitation_assigner.called?
    return I18n.t('session.notifications.invitation_create') if invitation_assigner.success?
    I18n.t("session.notifications.#{invitation_assigner.code}_invitation_create")
  end

  private

  def invitation_assigner
    @invitation_assigner ||= TokenInvitationUserAssigner.new(token_value, user)
  end

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
