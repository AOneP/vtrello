class ApplicationController < ActionController::Base

  before_action :authenticate
  before_action :set_locale

  def current_user
    return @current_user if defined? @current_user
    @current_user = User.find_by(id: session[:id])
  end
  helper_method :current_user
  helper_method :errors_for

  protected

  def authenticate
    unless current_user.present?
      redirect_to new_session_path, notice: I18n.t('application.notifications.authenticate')
    end
  end

  def redirect_if_logged
    service = SessionViewRedirector.new(
      current_user,
      TokenInvitationUserAssigner.new(params[:token], current_user).tap(&:assign).code
    )
    return unless service.should_be_redirected?
    redirect_to service.redirect_path, service.message
  end

  def set_locale
    cookies['locale'] = I18n.default_locale.to_s if cookies['locale'].nil?
    I18n.locale = cookies['locale'].to_sym
  end

  def errors_for(object)
    object.errors.full_messages.join("\n")
  end
end
