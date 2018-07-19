RSpec.describe Flight do
  subject { FactoryBot.create(:flight) }

  it { is_expected.to validate_presence_of(:name) }
  it do
    is_expected.to validate_uniqueness_of(:name).case_insensitive
                                                .scoped_to(:company_id)
  end
  it { is_expected.to validate_presence_of(:flys_at) }
  it { is_expected.to validate_presence_of(:lands_at) }
  it { is_expected.to validate_presence_of(:base_price) }
  it { is_expected.to validate_numericality_of(:base_price).is_greater_than(0) }

  it { is_expected.to have_many(:bookings) }
  it { is_expected.to belong_to(:company) }
end
