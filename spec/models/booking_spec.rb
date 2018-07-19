RSpec.describe Booking do
  subject { FactoryBot.create(:booking) }

  it { is_expected.to validate_presence_of(:seat_price) }
  it { is_expected.to validate_numericality_of(:seat_price).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:no_of_seats) }
  it do
    is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0)
  end
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:flight) }
end
