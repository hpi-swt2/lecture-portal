require 'rails_helper'

RSpec.describe "uploaded_files/show", type: :view do
  before(:each) do
    @uploaded_file = assign(:uploaded_file, UploadedFile.create!(
      :content_type => "Content Type",
      :filename => "Filename",
      :data => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Content Type/)
    expect(rendered).to match(/Filename/)
    expect(rendered).to match(//)
  end
end
