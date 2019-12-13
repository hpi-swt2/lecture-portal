require 'rails_helper'

RSpec.describe "uploaded_files/edit", type: :view do
  before(:each) do
    @uploaded_file = assign(:uploaded_file, UploadedFile.create!(
      :content_type => "MyString",
      :filename => "MyString",
      :data => ""
    ))
  end

  it "renders the edit uploaded_file form" do
    render

    assert_select "form[action=?][method=?]", uploaded_file_path(@uploaded_file), "post" do

      assert_select "input[name=?]", "uploaded_file[content_type]"

      assert_select "input[name=?]", "uploaded_file[filename]"

      assert_select "input[name=?]", "uploaded_file[data]"
    end
  end
end
