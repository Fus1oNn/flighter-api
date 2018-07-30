class BookingSerializer < ActiveModel::Serializer
  attribute :id
  attribute :no_of_seats
  attribute :seat_price

  belongs_to :user
  belongs_to :flight
end
