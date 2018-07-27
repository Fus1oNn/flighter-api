class SessionSerializer < ActiveModel::Serializer
  attribute :token
  has_one :user
end
