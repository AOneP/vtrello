class UsersController < ApplicationController

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to boards_path, notice: I18n.t('users.notifications.update')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname)
  end

end
