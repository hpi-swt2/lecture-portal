require "rails_helper"

RSpec.describe "feedbacks/edit", type: :view do
  before(:each) do
    @lecture = Lecture.create(name: "Test", enrollment_key: "test", is_running: true)
    @feedback = assign(:feedback, Feedback.create!(
                                    content: "MyText",
                                    lecture: @lecture
    ))
  end

  it "renders the edit feedback form" do
    render

    assert_select "form[action=?][method=?]", feedback_path(@feedback), "post" do
      assert_select "textarea[name=?]", "feedback[content]"

      assert_select "input[name=?]", "feedback[lecture_id]"
    end
  end
end
