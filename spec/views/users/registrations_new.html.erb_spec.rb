require "rails_helper"

RSpec.describe "users/sign_up", type: :view do
  before(:each) do
    assign(:user, User.new(
                    email: "user@example.com",
                    password: "password",
                    password_confirmation: "password",
                    is_student: true
    ))
  end

  it "renders user sign up form" do
    visit new_user_registration_path
    expect(page).to have_field("user[email]")
    expect(page).to have_field("user[password]")
    expect(page).to have_field("user[password_confirmation]")
    expect(page).to have_field("user[secret_key]")
  end
end
