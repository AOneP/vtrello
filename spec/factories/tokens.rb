FactoryBot.define do
  factory :token, class: Token do
    value { SecureRandom.uuid }
  end

  factory :token_invitation, class: Token::Invitation, parent: :token
  factory :token_confirmation, class: Token::Confirmation, parent: :token
  factory :token_change_password, class: Token::ChangePassword, parent: :token

end
