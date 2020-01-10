require "rails_helper"

describe "Uploading files", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "to a lecture" do
    before :each do
      data = file_fixture("LICENSE").read
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      @file = UploadedFile.new(filename: "LICENSE", content_type: "text/plain", data: data, allowsUpload: @lecture)
    end

    it "allows a lecture to be associated" do
      expect(@file.save).to be_truthy
      @file.reload
      expect(@file.allowsUpload).to eq(@lecture)
    end

    it "is known to its lecture" do
      @file.save
      @lecture.reload
      expect(@lecture.uploaded_files).to include(@file)
    end

  end
  context "to a course" do
    before :each do
      data = file_fixture("LICENSE").read
      @lecturer = FactoryBot.create(:user, :lecturer)
      @course = FactoryBot.create(:course, creator: @lecturer)
      @file = UploadedFile.new(filename: "LICENSE", content_type: "text/plain", data: data, allowsUpload: @course)
    end

    it "allows a course to be associated" do
      expect(@file.save).to be_truthy
      @file.reload
      expect(@file.allowsUpload).to eq(@course)
    end

    it "is known to its course" do
      @file.save
      @course.reload
      expect(@course.uploaded_files).to include(@file)
    end


  end
end