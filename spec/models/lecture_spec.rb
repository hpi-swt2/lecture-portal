require "rails_helper"

RSpec.describe Lecture, type: :model do
  it "is creatable using a Factory" do
    lecture = FactoryBot.create(:lecture)
    expect(lecture).to be_valid
  end

  it "is not valid without a name" do
    lecture = FactoryBot.build(:lecture, name: "")
    expect(lecture).not_to be_valid
  end

  it "is not valid without a enrollment key" do
    lecture = FactoryBot.build(:lecture, enrollment_key: "")
    expect(lecture).not_to be_valid
  end

  it "has all features enabled by default" do
    lecture = FactoryBot.build(:lecture)
    expect(lecture.polls_enabled).to be true
    expect(lecture.questions_enabled).to be true
  end

  it "new lectures have the status 'created' by default" do
    lecture = FactoryBot.build(:lecture)
    expect(lecture.status).to eq "created"
  end
end
