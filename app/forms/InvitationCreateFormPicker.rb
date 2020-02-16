class InvitationCreateFormPicker
  include ActiveModel::Model

  def initialize(invitation_params)
    @board_id = invitation_params[:board_id]
    @current_user = invitation_params[:current_user]
    @email = invitation_params[:email]
  end

  def form
    return InvitationCreateFormNewUser.new(invitation_params) unless user_exists?
    InvitationCreateForm.new(invitation_params)
  end

  def board
    return @board if defined? @board
    @board = Board.find_by(id: @board_id)
  end

  private

  def user_exists?
    User.find_by('lower(email) = ?', @email.downcase).present?
  end

  def invitation_params
    {
      board_id: @board_id,
      email: @email,
      current_user: @current_user
    }
  end
end


class InvitationCreateForm
  include ActiveModel::Model

  attr_accessor :board_id, :email, :current_user

  validate :board_exists?
  validate :check_invited_user
  validate :member_already_exist?
  validate :invited_user_is_current_user?
  validate :invited_user_is_board_owner?
  validate :invited_user_is_already_a_member?
  validate :invite_already_sent

  # sidekiq <- background job
  # dodatkowy case w przyszłości - jeżeli nowe zaproszenie dot. tego samego usera
  # to zrób used: true na starym i wyślij nowe zaproszenie z nowym tokenem
  # zamiast tłumaczyć userowi co się stało

  def save
    return false unless valid?
    InvitationToBoardMailer.send_mail_invite_existing_user(email, board_id).deliver!
    true
  end

  def board
    return @board if defined? @board
    @board = Board.find_by(id: board_id)
  end

  private

  def name
    return 'registrations' if invited_user == nil
    invited_user.email
  end

  def board_exists?
    return if board&.present?
    errors.add(:base, I18n.t('member_invitation.wrong.board_!exist'))
  end

  def check_invited_user
    return if invited_user&.present?
    errors.add(:base, I18n.t('member_invitation.wrong.invited_!exist'))
  end

  def member_already_exist?
    return unless invited_user.members.find_by(board_id: board_id).present?
    errors.add(:base, I18n.t('member_invitation.wrong.member_exist'))
  end

  def invited_user_is_current_user?
    return unless invited_user == current_user
    errors.add(:base, I18n.t('member_invitation.wrong.recipient_invitation'))
  end

  def invited_user_is_board_owner?
    return if board&.owner_id != invited_user.id
    errors.add(:base, I18n.t('member_invitation.wrong.owner_invitation'))
  end

  def invited_user_is_already_a_member?
    return unless invited_user&.boards&.find_by(id: board_id).present?
    errors.add(:base, I18n.t('member_invitation.wrong.member_exist'))
  end

  def invited_user
    return @invited_user if defined? @invited_user
    @invited_user = User.find_by('lower(email) = ?', email.downcase)
  end

  def invite_already_sent
    return if token.nil?
    return if token&.used? && !token&.expired?
    errors.add(:base, I18n.t('member_invitation.wrong.already_sent'))
  end

  def token
    return @token if defined? @token
    Token.where(email: email, target_id: board_id).last
  end

end

class InvitationCreateFormNewUser
  include ActiveModel::Model

  attr_accessor :board_id, :email, :current_user

  def save
    return false unless valid?
    InvitationToBoardMailer.send_mail_invite_new_user(email, board_id).deliver!
    true
  end
end
