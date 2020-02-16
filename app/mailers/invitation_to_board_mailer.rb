class InvitationToBoardMailer < ApplicationMailer

  def send_mail_invite_new_user(email, board_id)
    @token = Token::Invitation.create!(email: email, target_id: board_id)
    @redirect_url = redirect_url(:new_registration_url, @token)

    mail(to: email, subject: 'Zaproszenie do board w vTrello')
  end

  def send_mail_invite_existing_user(email, board_id)
    @token = Token::Invitation.create!(email: email, target_id: board_id)
    @redirect_url = redirect_url(:new_session_url, @token)

    mail(to: email, subject: 'Zaproszenie do board w vTrello')
  end

  private

  def redirect_url(url_method, token)
    [
      Rails.application.routes.url_helpers.send(url_method),
      "token=#{token.value}"
    ].join('?')
  end
end
