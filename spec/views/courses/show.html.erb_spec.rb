require "rails_helper"

RSpec.describe "courses/show", type: :view do
  before(:each) do
    @course = FactoryBot.create(:course)
    @lecture = FactoryBot.create(:lecture, name: "Name", enrollment_key: "Enrollment", status: "created",  course: @course)
    @current_user = FactoryBot.create(:user, :lecturer)
  end

  it "renders attributes of the course in <p>" do
    render
    expect(rendered).to match(/SWT2/)
    expect(rendered).to match(/ruby/)
    expect(rendered).to match(/open/)
  end

  it "renders a list of lectures" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 1
    assert_select "tr>td", text: "Enrollment".to_s, count: 1
    assert_select "tr>td", text: "created".to_s, count: 1
  end
end
