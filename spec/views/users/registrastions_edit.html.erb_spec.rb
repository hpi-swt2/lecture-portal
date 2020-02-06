require "rails_helper"

RSpec.describe "users/edit", type: :view do
  let(:valid_session) { {} }
  before(:each) do
    assign(:user, User.new(
                    email: "user@example.com",
                    password: "password",
                    password_confirmation: "password",
                    is_student: true
    ))
  end

  it "renders user editation form" do
    login_student
    visit edit_user_registration_path
    expect(page).to have_field("user[email]")
    expect(page).to have_field("user[password]")
    expect(page).to have_field("user[password_confirmation]")
    expect(page).to have_field("user[current_password]")
    # user can not change from student to lecturer or vice versa
  end


  def login_student
    student = FactoryBot.create(:user, :student)
    sign_in(student, scope: :user)
  end
end
