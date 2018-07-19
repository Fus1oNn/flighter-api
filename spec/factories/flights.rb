FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "Flight-#{n}" }
    no_of_seats 100
    base_price 10
    flys_at { 2.days.from_now }
    lands_at { 3.days.from_now }
    company
  end
end
