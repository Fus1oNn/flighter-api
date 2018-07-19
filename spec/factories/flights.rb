FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "Flight-#{n}" }
    no_of_seats 100
    company
  end

  trait :flys_at_1_day_after_lands_at do
    flys_at { 1.day.ago }
    lands_at { Time.current }
  end

  trait :lands_at_1_day_after_flys_at do
    flys_at { Time.current }
    lands_at { 1.day.ago }
  end

  trait :big_price do
    base_price 5
  end

  trait :zero_price do
    base_price 0
  end
end
