require "rails_helper"

describe "Upload files", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  before :each do
    # could not get fixture_file_upload to find the file
    @data = file_fixture("LICENSE")
    @data_umlauts = file_fixture("FileWithUmlautsÜÖÄüöä")
    @lecturer = FactoryBot.create(:user, :lecturer)
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    sign_in @lecturer
    visit(new_course_lecture_uploaded_file_path(@lecture.course, @lecture))
  end

  it "uploads a valid file" do
    expect(UploadedFile.count).to be(0)
    find(:id, "uploaded_file_lecture").set(@lecture.id)
    find(:id, "uploaded_file_attachment").set(@data)
    click_on("Create Uploaded file")
    expect(UploadedFile.count).to be(1)
  end

  it "uploads no file without data" do
    expect(UploadedFile.count).to be(0)
    find(:id, "uploaded_file_lecture").set(@lecture.id)
    click_on("Create Uploaded file")
    expect(UploadedFile.count).to be(0)
  end

  it "uploads a link" do
    expect(UploadedFile.count).to be(0)
    find(:id, "uploaded_file_lecture").set(@lecture.id)
    find(:id, "uploaded_file_link").set("https://hpi.de")
    click_on("Create Uploaded file")
    expect(UploadedFile.count).to be(1)
  end

  it "uploads a valid file with correct type" do
      expect(UploadedFile.count).to be(0)
      find(:id, "uploaded_file_lecture").set(@lecture.id)
      find(:id, "uploaded_file_attachment").set(@data)
      click_on("Create Uploaded file")
      expect(UploadedFile.count).to be(1)
    end

  it "uploads a valid file with umlauts and with correct type" do
    expect(UploadedFile.count).to be(0)
    find(:id, "uploaded_file_lecture").set(@lecture.id)
    find(:id, "uploaded_file_attachment").set(@data_umlauts)
    click_on("Create Uploaded file")
    expect(UploadedFile.count).to be(1)
  end

  it "links back to the lectures show page" do
    expect(page).to have_link("Back", href: course_lecture_path(@lecture.course, @lecture))
  end
end
