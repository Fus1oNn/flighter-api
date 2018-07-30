class UserSerializer < ActiveModel::Serializer
  attribute :id
  attribute :first_name
  attribute :last_name
  attribute :email

  has_many :bookings
end
