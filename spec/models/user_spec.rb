require 'rails_helper'

RSpec.describe User, type: :model do
  it "is creatable using a Factory" do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = FactoryBot.build(:user, email: '')
    expect(user).to_not be_valid
  end

  it "is not valid without a password" do
    user = FactoryBot.build(:user, password: nil)
    expect(user).not_to be_valid
  end

  it "is not valid without an is student status" do
    user = FactoryBot.build(:user, is_student: "")
    expect(user).not_to be_valid
  end
end
