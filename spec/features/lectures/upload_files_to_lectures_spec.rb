require "rails_helper"

describe "The show lecture page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  describe "as a lecturer" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      sign_in @lecturer
    end


  end

end