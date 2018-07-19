FactoryBot.define do
  factory :booking do
    big_seat_price
    enough_seats
    user
    flight
  end

  trait :big_seat_price do
    seat_price 100
  end

  trait :no_seat_price do
    seat_price 0
  end

  trait :enough_seats do
    no_of_seats 100
  end

  trait :no_seats do
    no_of_seats 0
  end
end
