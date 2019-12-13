require 'rails_helper'

RSpec.describe "uploaded_files/index", type: :view do
  before(:each) do
    assign(:uploaded_files, [
      UploadedFile.create!(
        :content_type => "Content Type",
        :filename => "Filename",
        :data => ""
      ),
      UploadedFile.create!(
        :content_type => "Content Type",
        :filename => "Filename",
        :data => ""
      )
    ])
  end

  it "renders a list of uploaded_files" do
    render
    assert_select "tr>td", :text => "Content Type".to_s, :count => 2
    assert_select "tr>td", :text => "Filename".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
