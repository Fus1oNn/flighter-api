class Booking < ApplicationRecord
  validates :seat_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validate :flight_in_the_future

  belongs_to :user
  belongs_to :flight

  def flight_in_the_future
    return if flight && (Time.current < flight.flys_at)

    errors.add(:flys_at, "can't be in the past")
  end
end
