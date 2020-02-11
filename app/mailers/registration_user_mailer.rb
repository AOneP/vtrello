class RegistrationUserMailer < ApplicationMailer
  def send_mail(email)
    @token = Token.create(email: email)
    mail(to: email, subject: 'Rejestracja vTrello')
  end
end
