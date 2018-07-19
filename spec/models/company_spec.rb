RSpec.describe Company do
  subject { FactoryBot.create(:company) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
  it { is_expected.to have_many(:flights) }
  it { is_expected.to validate_presence_of(:no_of_seats) }
  it do
    is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0)
  end
end
