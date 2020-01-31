require "rails_helper"

RSpec.describe "polls/index", type: :view do
  before(:each) do
    @lecture = FactoryBot.create(:lecture)
    assign(:polls, [
      Poll.create!(
        title: "Title1",
        is_multiselect: false,
        lecture_id: @lecture.id,
        status: "stopped"
      ),
      Poll.create!(
        title: "Title2",
        is_multiselect: false,
        lecture_id: @lecture.id,
        status: "running"
      )
    ])
  end

  it "renders a list of polls for lecturer" do
    login_lecturer
    visit course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id)
    find(:table_row, { "Title" => "Title1", "Active" => "No" }, {})
    find(:table_row, { "Title" => "Title2", "Active" => "Yes" }, {})
  end

  it "renders a list of polls for student" do
    login_student
    visit course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id)
    find(:table_row, { "Title" => "Title1", "Active" => "No" }, {})
    find(:table_row, { "Title" => "Title2", "Active" => "Yes" }, {})
  end

  def login_lecturer
    user = FactoryBot.create(:user, :lecturer)
    sign_in(user, scope: :user)
  end

  def login_student
    user = FactoryBot.create(:user, :student)
    sign_in(user, scope: :user)
  end
end
