require "rails_helper"

describe "The all lectures page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "being signed in as a lecturer that created a lecture" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      sign_in @lecturer
    end

    it "should not have a delete button" do
      visit(edit_lecture_path(@lecture))
      expect(page).to_not have_link("Delete")
    end
  end
end