RSpec.describe User do
  subject { FactoryBot.create(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('email@email.com').for(:email) }
  it { is_expected.not_to allow_value('em ail@gmail.com').for(:email) }
  it { is_expected.to have_many(:bookings) }
end
