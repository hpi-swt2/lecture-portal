require "rails_helper"

RSpec.describe "users/sign_in", type: :view do
  before(:each) do
    assign(:user, User.new(
                    email: "user@example.com",
                    password: "password",
                    password_confirmation: "password",
                    is_student: true
    ))
  end

  it "renders user sign in form" do
    visit new_user_session_path
    expect(page).to have_field("user[email]")
    expect(page).to have_field("user[password]")
    expect(page).to have_field("user[remember_me]")
  end

  it "contains session management links" do
    visit new_user_session_path
    expect(page).to have_link("Sign up")
    expect(page).to_not have_link("Forgot your password?")
  end
end
