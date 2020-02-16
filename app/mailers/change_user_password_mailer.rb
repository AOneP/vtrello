class ChangeUserPasswordMailer < ApplicationMailer
  def send_mail(current_user)
    @token = Token::ChangePassword.create(email: current_user.email)
    mail(to: current_user.email, subject: 'Zmień hasło w vTrello')
  end
end
