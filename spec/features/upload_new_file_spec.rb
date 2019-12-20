require "rails_helper"

describe "Show uploaded files index page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  before :each do
    @data = file_fixture("LICENSE")
    @lecturer = FactoryBot.create(:user, :lecturer)
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    sign_in @lecturer
  end

  it "uploads a valid file" do
    expect(UploadedFile.count).to be(0)
    visit(new_uploaded_file_path)
    find(:id, "uploaded_file_lecture").set(@lecture.id)
    find(:id, "uploaded_file_attachment").set(@data)
    select "Summary", from: "uploaded_file_uploadedFileType"
    click_on("Create Uploaded file")
    expect(UploadedFile.count).to be(1)
    end

  it "uploads no file without lecture" do
  expect(UploadedFile.count).to be(0)
  visit(new_uploaded_file_path)
  find(:id, "uploaded_file_attachment").set(@data)
  select "Summary", from: "uploaded_file_uploadedFileType"
  click_on("Create Uploaded file")
  expect(UploadedFile.count).to be(0)
  end

  it "uploads no file without data" do
    expect(UploadedFile.count).to be(0)
    visit(new_uploaded_file_path)
    find(:id, "uploaded_file_lecture").set(@lecture.id)
    select "Summary", from: "uploaded_file_uploadedFileType"
    click_on("Create Uploaded file")
    expect(UploadedFile.count).to be(0)
  end

  it "uploads a valid file with correct type" do
    expect(UploadedFile.count).to be(0)
    visit(new_uploaded_file_path)
    find(:id, "uploaded_file_lecture").set(@lecture.id)
    find(:id, "uploaded_file_attachment").set(@data)
    select "Summary", from: "uploaded_file_uploadedFileType"
    click_on("Create Uploaded file")
    expect(UploadedFile.find(1).Summary?).to be(true)
  end
end
