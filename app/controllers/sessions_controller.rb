class SessionsController < ApplicationController
  skip_before_action :authenticate, only:[:new, :create]

  def new
    @form = SessionForm.new
  end

  def create
    @form = SessionForm.new(session_params)
    if @form.save
      session[:id] = @form.user.id
      redirect_to boards_path, notice: I18n.t('session.notifications.create')
    else
      render :new
    end
  end

  def destroy
    session[:id] = nil
    redirect_to new_session_path, notice: I18n.t('session.notifications.destroy')
  end

  private

  def session_params
    params.permit(:email, :login, :password)
  end

end
