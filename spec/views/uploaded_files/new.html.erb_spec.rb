require 'rails_helper'

RSpec.describe "uploaded_files/new", type: :view do
  before(:each) do
    assign(:uploaded_file, UploadedFile.new(
      :content_type => "MyString",
      :filename => "MyString",
      :data => ""
    ))
  end

  it "renders new uploaded_file form" do
    render

    assert_select "form[action=?][method=?]", uploaded_files_path, "post" do

      assert_select "input[name=?]", "uploaded_file[content_type]"

      assert_select "input[name=?]", "uploaded_file[filename]"

      assert_select "input[name=?]", "uploaded_file[data]"
    end
  end
end
