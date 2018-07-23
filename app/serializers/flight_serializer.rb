class FlightSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :no_of_seats
  attribute :base_price
  attribute :flys_at
  attribute :lands_at

  belongs_to :company
  has_many :bookings
end
