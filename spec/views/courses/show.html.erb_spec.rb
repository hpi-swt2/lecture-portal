require "rails_helper"

RSpec.describe "courses/show", type: :view do
  before(:each) do
    @course = FactoryBot.create(:course)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/SWT2/)
    expect(rendered).to match(/ruby/)
    expect(rendered).to match(/open/)
  end
end
