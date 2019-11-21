require 'rails_helper'

RSpec.describe "questions/index", type: :view do
  before(:each) do
    assign(:questions, [
      Question.create!(
        :author => "MyText",
        :content => "MyText"
      ),
      Question.create!(
        :author => "MyText1",
        :content => "MyText1"
      )
    ])
  end

  it "renders a list of questions" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText1".to_s, :count => 2
  end
end
