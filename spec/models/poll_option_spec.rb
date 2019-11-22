require "rails_helper"

RSpec.describe PollOption, type: :model do
  it "can be instantiated" do
    poll_option = FactoryBot.create :poll_option
    expect(poll_option).to be_valid
  end

  it "is not valid without a description" do
    poll_option = FactoryBot.build :poll_option, description: ""
    expect(poll_option).to_not be_valid
  end
end
