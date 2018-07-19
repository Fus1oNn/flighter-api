class Company < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :flights, dependent: :destroy
end
