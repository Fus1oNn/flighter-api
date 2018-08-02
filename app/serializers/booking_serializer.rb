class BookingSerializer < ActiveModel::Serializer
  attribute :id
  attribute :no_of_seats
  attribute :seat_price
  attribute :user_id
  attribute :flight_id

  belongs_to :user
  belongs_to :flight
end
