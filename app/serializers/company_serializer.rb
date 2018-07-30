class CompanySerializer < ActiveModel::Serializer
  attribute :id
  attribute :name

  has_many :flights
end
