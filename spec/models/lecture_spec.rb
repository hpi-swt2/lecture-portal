require 'rails_helper'

RSpec.describe Lecture, type: :model do

  it "is creatable using a Factory" do
    lecture = FactoryBot.create(:lecture)
    expect(lecture).to be_valid
  end

  it "is not valid without a name" do
  	lecture = FactoryBot.build(:lecture, name: '')
  	expect(lecture).not_to be_valid
  end

  it "is not valid without a enrollment key" do
  	lecture = FactoryBot.build(:lecture, enrollment_key: '')
  	expect(lecture).not_to be_valid
  end

  it "is not valid without an is running status" do
  	lecture = FactoryBot.build(:lecture, is_running: '')
  	expect(lecture).not_to be_valid
  end

end
