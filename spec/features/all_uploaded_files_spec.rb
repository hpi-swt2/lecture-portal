require "rails_helper"

describe "Show uploaded files index page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  before :each do
    data = file_fixture("LICENSE").read
    @lecturer = FactoryBot.create(:user, :lecturer)
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    file = UploadedFile.new(filename: "LICENSE", content_type: "text/plain", data: data, allowsUpload: @lecture)
    file.Notes!
    file.save
    sign_in @lecturer
  end

  it "should show the license content type" do
    visit uploaded_files_path
    # setup worked, else rest of test is pointless
    expect(UploadedFile.all.size).to eq(1)
    expect(find(:table_row, {"Filename" => "LICENSE" }, {})).to have_text("text/plain")
  end

  it "should show the license text" do
    visit uploaded_files_path
    # setup worked, else rest of test is pointless
    expect(UploadedFile.all.size).to eq(1)
    expect(find(:table_row, {"Filename" => "LICENSE" }, {})).to have_text("WITHOUT WARRANTY OF ANY KIND")
    end

  it "should show the license text" do
    visit uploaded_files_path
    # setup worked, else rest of test is pointless
    expect(UploadedFile.all.size).to eq(1)
    expect(find(:table_row, {"Filename" => "LICENSE" }, {})).to have_text("WITHOUT WARRANTY OF ANY KIND")
    end

  it "should show the \"Notes\" category" do
    visit uploaded_files_path
    # setup worked, else rest of test is pointless
    expect(UploadedFile.all.size).to eq(1)
    expect(find(:table_row, {"Filename" => "LICENSE" }, {})).to have_text "Notes"
  end
end
