RSpec.describe Company do
  subject { FactoryBot.create(:company) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
  it { is_expected.to have_many(:flights) }
end
