require "rails_helper"

RSpec.describe "polls/index", type: :view do
  before(:each) do
    login_lecturer
    @lecture = FactoryBot.create(:lecture)
    assign(:polls, [
      Poll.create!(
        title: "Title1",
        is_multiselect: false,
        lecture_id: @lecture.id
      ),
      Poll.create!(
        title: "Title2",
        is_multiselect: false,
        lecture_id: @lecture.id
      )
    ])
  end

  it "renders a list of polls" do
    visit course_lecture_polls_path(course_id:@lecture.course.id, lecture_id:@lecture.id)
    expect(page).to have_text("Title1")
    expect(page).to have_text("Title2")
  end
  def login_lecturer
    user = FactoryBot.create(:user, :lecturer)
    sign_in(user, scope: :user)
  end
end
