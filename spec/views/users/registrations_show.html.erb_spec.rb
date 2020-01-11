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

  it "renders user email" do
    login_student
    visit users_show_path
    expect(page).to have_text("Email")
    expect(page).to have_text(@student.email)
  end

  it "renders user calendar feed" do
    login_student
    visit users_show_path
    expect(page).to have_text("Calendar Feed")
  end

  def login_student
    student = FactoryBot.create(:user, :student)
    @student = student
    sign_in(student, scope: :user)
  end
end
