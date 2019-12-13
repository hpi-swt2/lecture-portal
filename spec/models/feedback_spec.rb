require "rails_helper"

RSpec.describe Feedback, type: :model do
  require "rails_helper"
  it "is creatable using a Factory" do
    feedback = FactoryBot.create(:feedback)
    expect(feedback).to be_valid
  end

  it "is not valid without an lecture" do
    feedback = FactoryBot.build(:feedback, lecture: nil)
    expect(feedback).to_not be_valid
  end
end
