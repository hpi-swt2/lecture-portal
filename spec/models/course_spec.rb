require "rails_helper"

RSpec.describe Course, type: :model do
  before(:each) do
    @course = FactoryBot.build(:course)
    @lecture = FactoryBot.build(:lecture)
    @lecture.course = @course
  end

  it "is creatable using a Factory" do
    expect(@course).to be_valid
  end

  it "is not valid without a name" do
    @course.name = ""
    expect(@course).not_to be_valid
  end

  it "persists lecturer as creator" do
    expect(@course.creator).to be_instance_of(User)
  end

  it "is not valid without a creator" do
    @course.creator = nil
    expect(@course).not_to be_valid
  end

  it "is open by default after creation" do
    expect(@course.status).to eq "open"
  end
  it "can be destroyed after one of its lectures was archived" do
    @lecture.update(status: "archived", date: Date.yesterday)
    expect(@lecture).to be_valid
    expect { @course.destroy }.to_not raise_error
  end
end
