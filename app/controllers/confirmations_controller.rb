class ConfirmationsController < ApplicationController
  skip_before_action :authenticate

  def new
    RegistrationUserMailer.send_mail(user.email).deliver!
    redirect_to new_session_path
  end

  def show
    form = ConfirmationUserEmailForm.new(token: token)
    if form.save
      render partial: 'token_accepted'
    else
      render partial: form.error_partial, status: 422
    end
  end

  private

  def token
    return @token if defined? @token
    @token = Token.find_by(value: params[:token])
  end

  def user
    @user ||= User.find_by!(email: token&.email)
  end

end
