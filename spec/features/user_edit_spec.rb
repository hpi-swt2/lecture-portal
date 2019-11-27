require "rails_helper"

describe "Editing the user attributes on the 'user edit' page", type: :feature do
  include Devise::Test::IntegrationHelpers

  context "without being logged in" do
    before(:each) do
      visit edit_user_registration_path
    end

    scenario "shows an error message" do
      expect(page).to have_css('.alert-danger', count: 1)
    end

    scenario "redirects to the log in page" do
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "while logged in as a student" do
    before(:each) do
      @student = FactoryBot.create(:user, :student)
      sign_in @student
      visit edit_user_registration_path
    end

    scenario "does not show an error" do
      expect(page).to_not have_css('.alert-danger')
      expect(page).to have_current_path(edit_user_registration_path)
    end
    
    scenario "shows previously set email in input field" do
      expect(find_field('user[email]').value).to eq @student.email
    end

    scenario "shows inputs for setting the password" do
      expect(page).to have_field('user[password]')
      expect(page).to have_field('user[password_confirmation]')
    end
  end
end