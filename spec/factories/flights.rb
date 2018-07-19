FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "Flight-#{n}" }
    no_of_seats 100
    base_price 10
    lands_at_1_day_after_flys_at
    company
  end

  trait :flys_at_1_day_after_lands_at do
    flys_at { 3.days.from_now }
    lands_at { 2.days_from_now }
  end

  trait :lands_at_1_day_after_flys_at do
    flys_at { 2.days.from_now }
    lands_at { 3.days.from_now }
  end

  trait :big_price do
    base_price 5
  end

  trait :zero_price do
    base_price 0
  end
end
