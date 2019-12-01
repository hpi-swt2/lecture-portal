require "rails_helper"

RSpec.describe Question, type: :model do
  it "is creatable using a Factory" do
    question = FactoryBot.create(:question)
    expect(question).to be_valid
  end

  it "is not valid with an empty content" do
    question = FactoryBot.build(:question, content: "")
    expect(question).to_not be_valid
  end

  it "is not valid without an author" do
    question = FactoryBot.build(:question, author: nil)
    expect(question).to_not be_valid
  end
end
