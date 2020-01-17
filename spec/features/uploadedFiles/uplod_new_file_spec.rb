require "rails_helper"

describe "Upload files", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  before :each do
    # could not get fixture_file_upload to find the file
    @data = file_fixture("LICENSE")
    @data_umlauts = file_fixture("FileWithUmlautsÜÖÄüöä")
    @lecturer = FactoryBot.create(:user, :lecturer)
    @student = FactoryBot.create(:user, :student)
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    sign_in @lecturer
  end
  context "for lectures" do
    before :each do
      visit(new_course_lecture_uploaded_file_path(@lecture.course, @lecture))
    end
    it "uploads a valid file" do
      expect(UploadedFile.count).to be(0)
      find(:id, "uploaded_file_attachment").set(@data)
      click_on("Create Uploaded file")
      expect(UploadedFile.count).to be(1)
    end

    it "uploads no file without data" do
      expect(UploadedFile.count).to be(0)
      click_on("Create Uploaded file")
      expect(UploadedFile.count).to be(0)
    end

    it "uploads a link" do
      expect(UploadedFile.count).to be(0)
      find(:id, "uploaded_file_link").set("https://hpi.de")
      click_on("Create Uploaded file")
      expect(UploadedFile.count).to be(1)
    end

    it "uploads a valid file with correct type" do
      expect(UploadedFile.count).to be(0)
      find(:id, "uploaded_file_attachment").set(@data)
      click_on("Create Uploaded file")
      expect(UploadedFile.count).to be(1)
    end

    it "uploads a valid file with umlauts and with correct type" do
      expect(UploadedFile.count).to be(0)
      find(:id, "uploaded_file_attachment").set(@data_umlauts)
      click_on("Create Uploaded file")
      expect(UploadedFile.count).to be(1)
    end
    it "links back to the lectures show page" do
      expect(page).to have_link("Back", href: course_lecture_path(@lecture.course, @lecture))
    end

    # students are not allowed to upload files
    it "redirects a student away" do
      sign_in @student
      @lecture.join_lecture(@student)
      visit(new_course_lecture_uploaded_file_path(@lecture.course, @lecture))
      expect(current_path).to eq(course_lecture_path(@lecture.course, @lecture))
    end
  end

  context "for courses" do
    before :each do
      visit(new_course_uploaded_file_path(@lecture.course))
    end

    it "uploads a valid file with umlauts and with correct type by a lecturer" do
        expect(UploadedFile.count).to be(0)
        find(:id, "uploaded_file_attachment").set(@data_umlauts)
        click_on("Create Uploaded file")
        expect(UploadedFile.count).to be(1)
      end

    it "uploads a valid file with umlauts and with correct type by a student" do
      sign_in @student
      expect(UploadedFile.count).to be(0)
      find(:id, "uploaded_file_attachment").set(@data_umlauts)
      click_on("Create Uploaded file")
      expect(UploadedFile.count).to be(1)
    end
    
    it "links back to the course show page" do
      expect(page).to have_link("Back", href: course_path(@lecture.course))
    end
  end
end
