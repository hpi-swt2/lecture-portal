require "rails_helper"

RSpec.describe "feedbacks/index", type: :view do
  before(:each) do
    @lecture = Lecture.create(name: "Test", enrollment_key: "test", is_running: true)
    assign(:feedbacks, [
      Feedback.create!(
        content: "MyText",
        lecture: @lecture
      ),
      Feedback.create!(
        content: "MyText",
        lecture: @lecture
      )
    ])
  end

  it "renders a list of feedbacks" do
    render
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: @lecture.to_s, count: 2
  end
end
