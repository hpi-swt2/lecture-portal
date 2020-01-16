require "rails_helper"

RSpec.describe LectureComprehensionStamp, type: :model do
  before (:each) do
    @stamp = FactoryBot.create(:lecture_comprehension_stamp)
  end
  it "is creatable using a Factory" do
    expect(@stamp).to be_valid
  end

  it "is not valid without a status" do
    @stamp.status = nil
    expect(@stamp).to_not be_valid
  end

  it "is not valid without a status out of range" do
    @stamp.status = LectureComprehensionStamp.number_of_states + 1
    expect(@stamp).not_to be_valid
  end

  it "returns a creation timestamp" do
    expect(@stamp.timestamp).to be < Time.now
  end

  #   it "does ... on call of eliminate" do
  #   end
end
