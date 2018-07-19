FactoryBot.define do
  factory :booking do
    seat_price 100
    no_of_seats 100
    user
    flight
  end
end
