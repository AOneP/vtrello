FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |n| "adrian#{n}@example.com" }
    nickname { 'asone' }
    password { '1' }
  end
end
