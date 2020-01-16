require 'rails_helper'

RSpec.describe "calendars/new", type: :view do
  before(:each) do
    assign(:calendar, Calendar.new(
      :ical => "MyText"
    ))
  end

  it "renders new calendar form" do
    render

    assert_select "form[action=?][method=?]", calendars_path, "post" do

      assert_select "textarea[name=?]", "calendar[ical]"
    end
  end
end
