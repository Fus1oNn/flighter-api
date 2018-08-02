FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@email.com" }
    first_name 'Pero'
    password 'password'
    sequence(:token) { |t| "token#{t}" }
  end
end
