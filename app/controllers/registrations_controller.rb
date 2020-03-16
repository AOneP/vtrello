class RegistrationsController < ApplicationController
  skip_before_action :authenticate, only:[:new, :create]

  def new
    @form = RegistrationUserForm.new
  end

  def create
    @form = RegistrationUserForm.new(user_params.merge(token_value: params['token']))
    if @form.save
      redirect_to new_session_path, notice: @form.success_notice
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :nickname, :password)
  end
end
