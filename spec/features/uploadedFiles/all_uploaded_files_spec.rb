require "rails_helper"

describe "The uploaded files index page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "having uploaded one file" do
    before :each do
      data = file_fixture("LICENSE.md").read
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      @file = UploadedFile.new(filename: "LICENSE", content_type: "text/plain", data: data, allowsUpload: @lecture, author: @lecturer, extension: ".md")
      @file.save
      sign_in @lecturer
    end

    it "has an author" do
      expect(@file.author).to_not be_nil
      expect(@file).to be_valid
    end

    it "should not be vaild without an author" do
      @file.author = nil
      expect(@file).to_not be_valid
    end

    it "should be assosiatable from the author" do
      file_author = @file.author
      expect(file_author.uploaded_files.include?(@file)).to be_truthy
    end

    it "should show the license content type" do
      visit course_lecture_uploaded_files_path(@lecture.course, @lecture)
      # setup worked, else rest of test is pointless
      expect(UploadedFile.all.size).to eq(1)
      expect(page).to have_link("LICENSE")
    end

    it "should show a download file link as it's name" do
      visit course_lecture_uploaded_files_path(@lecture.course, @lecture)
      expect(page).to have_link "LICENSE", href: course_lecture_uploaded_file_path(@lecture.course, @lecture, @file), count: 1
    end

    it "should download the file when clicking the link" do
      visit course_lecture_uploaded_files_path(@lecture.course, @lecture)
      click_on "LICENSE"
      expect(page.body).to eql @file.data
      expect(page.response_headers["Content-Type"]).to eql @file.content_type
    end

    it "download should have file extension attached" do
      visit course_lecture_uploaded_files_path(@lecture.course, @lecture)
      click_on "LICENSE"
      expect(page.body).to eql @file.data
      expect(page.response_headers["Content-Disposition"]).to eq 'attachment; filename="LICENSE.md"'
    end

  end
end
