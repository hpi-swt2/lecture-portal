require "rails_helper"

RSpec.describe "lectures/show", type: :view do
  before(:each) do
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "Name",
                                  enrollment_key: "Enrollment Key",
                                  is_running: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Enrollment Key/)
    expect(rendered).to match(/false/)
  end
end
