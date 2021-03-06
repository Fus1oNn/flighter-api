class Flight < ApplicationRecord
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: :company_id }
  validates :flys_at, presence: true
  validates :lands_at, presence: true
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validate :flys_at_before_lands_at

  belongs_to :company
  has_many :bookings, dependent: :destroy

  def flys_at_before_lands_at
    return if flys_at.blank? || lands_at.blank?
    errors.add(:lands_at, "can't be before flys_at") unless flys_at < lands_at
  end
end
