class RegistrationsController < ApplicationController
  skip_before_action :authenticate, only:[:new, :create]

  def new
    @form = RegistrationUserForm.new
  end

  def create
    @form = RegistrationUserForm.new(user_params)
    if @form.save
      redirect_to new_session_path, notice: I18n.t('registrations.notifications.create')
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :nickname, :password)
  end

end
