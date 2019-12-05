require "rails_helper"

RSpec.describe "lectures/show", type: :view do
  before(:each) do
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "Name",
                                  enrollment_key: "Enrollment Key",
                                  status: "created",
                                  lecturer: FactoryBot.create(:user, :lecturer, email: "bp@hpi.de")
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Enrollment Key/)
    expect(rendered).to match(/created/)
  end

  it "renders navbar tabs" do
    render
    assert_select "a", "Dashboard"
    assert_select "a", "Feedback"
    assert_select "a", "Questions"
    assert_select "a", "Settings"
    assert_select "a", "Polls"
  end
end
