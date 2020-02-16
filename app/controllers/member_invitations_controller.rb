class MemberInvitationsController < ApplicationController

  def new
    @invitation_form = InvitationCreateFormPicker.new(board_id: params[:board_id])
  end

  def create
    @invitation_form = InvitationCreateFormPicker.new(invitation_params).form
    if @invitation_form.save
      redirect_to boards_path, notice: I18n.t('member_invitation.notifications.invite_sent')
    else
      render :new
    end
  end

  private

  def invitation_params
    params.permit(:board_id, :email).merge(current_user: current_user)
  end
end
