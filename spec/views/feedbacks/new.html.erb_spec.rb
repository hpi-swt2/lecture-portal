require "rails_helper"

RSpec.describe "feedbacks/new", type: :view do
  before(:each) do
    assign(:feedback, Feedback.new(
                        content: "MyText",
                        lecture: nil
    ))
  end

  it "renders new feedback form" do
    render

    assert_select "form[action=?][method=?]", feedbacks_path, "post" do
      assert_select "textarea[name=?]", "feedback[content]"

      assert_select "input[name=?]", "feedback[lecture_id]"
    end
  end
end
