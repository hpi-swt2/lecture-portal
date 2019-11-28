require "rails_helper"

RSpec.describe "feedbacks/show", type: :view do
  before(:each) do
    @lecture = Lecture.create(name: "Test", enrollment_key: "test", is_running: true)
    @feedback = assign(:feedback, Feedback.create!(
                                    content: "MyText",
                                    lecture: @lecture
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
