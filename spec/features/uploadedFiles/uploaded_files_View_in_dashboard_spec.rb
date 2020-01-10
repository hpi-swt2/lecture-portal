require "rails_helper"

describe "The lecture dashboard page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "having uploaded two files" do
    before :each do
      @link_addr = "https://hpi.de"
      @file = file_fixture("LICENSE")
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      @lecture.set_active
      @lecture.save
      @course = @lecture.course
      @link = UploadedFile.new(data: @link_addr, allowsUpload: @lecture, isLink: true)
      @link.save
      @filename = "LICENSE"
      @file = UploadedFile.new(filename: @filename, content_type: "text/plain", data: @file.read, allowsUpload: @lecture, isLink: false)
      @file.save
      sign_in @lecturer
    end

    it "shows the link" do
      visit course_lecture_path(@course, @lecture)
      expect(page).to have_link(@link_addr)
    end

    it "shows the file name" do
      visit course_lecture_path(@course, @lecture)
      expect(page).to have_text(@filename)
    end

    it "has the \"Download\" button" do
      visit course_lecture_path(@course, @lecture)
      expect(page).to have_link("Download")
    end

  end
end
