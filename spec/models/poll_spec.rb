require "rails_helper"

RSpec.describe Poll, type: :model do
  it "can be instantiated" do
    poll = FactoryBot.create :poll
    expect(poll).to be_valid
  end

  it "can have multiple poll options" do
   poll = FactoryBot.create :poll
   poll_option1 = FactoryBot.build(:poll_option, poll: poll)
   poll_option2 = FactoryBot.build(:poll_option, poll: poll)

   poll.poll_options = [poll_option1, poll_option2]
   expect(poll).to be_valid
 end

 it "is active by default" do
   poll = FactoryBot.create :poll
   expect(poll.is_active).to equal(true)
 end
end
