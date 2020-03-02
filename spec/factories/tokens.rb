FactoryBot.define do
  factory :token, class: Token do
    value { SecureRandom.uuid }
  end
end
