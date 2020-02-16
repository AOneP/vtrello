class SessionViewRedirector

  def initialize(current_user, assigner_code)
    @assigner_code = assigner_code
    @current_user = current_user
  end

  def should_be_redirected?
    @should_be_redirected ||= @current_user.present?
  end

  def redirect_path
    return unless should_be_redirected?
    Rails.application.routes.url_helpers.boards_path
  end

  def message
    return unless should_be_redirected?
    return { notice: I18n.t('member_invitation.notifications.success') } if @assigner_code == :success
    return { notice: I18n.t('session.notifications.already_logged') } if @assigner_code.nil?

    { alert: I18n.t("application.notifications.board_invitations.#{@assigner_code}") }
  end
end
