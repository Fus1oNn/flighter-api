class User < ApplicationRecord
  has_secure_password
  has_secure_token

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :first_name, presence: true, length: { minimum: 2 }

  has_many :bookings, dependent: :destroy
end
