FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |n| "adrian#{n}@example.com" }
    sequence(:nickname) { |n| "aone#{n}" } 
    password { '1' }
  end
end
