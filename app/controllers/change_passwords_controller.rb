class ChangePasswordsController < ApplicationController

  before_action :authorize_current_user, only: [:edit, :update]

  def create
    ChangeUserPasswordMailer.send_mail(current_user).deliver!
    redirect_to boards_path, notice: I18n.t('password_change.notifications.email_sent')
  end

  def edit
    @user_password_form = ChangeUserPasswordForm.new
  end

  def update
    @user_password_form = ChangeUserPasswordForm.new(password_params)
    if @user_password_form.save
      redirect_to boards_path, notice: I18n.t('password_change.notifications.update')
    else
      redirect_to boards_path, alert: errors_for(@user_password_form)
    end
  end

  private

  def password_params
    params.permit(:password, :new_password, :new_password_confirmation)
          .merge(current_user: current_user, token: token)
  end

  def token
    return @token if defined? @token
    @token = Token.find_by(value: params[:token_value])
  end

  def authorize_current_user
    if token.nil? || current_user.email != token.email
      redirect_to root_path, alert: I18n.t('password_change.notifications.alert')
    end
  end

end
