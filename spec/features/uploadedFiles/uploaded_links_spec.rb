require "rails_helper"

describe "The uploaded files index page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "having uploaded one file" do
    before :each do
      @data = "https://hpi.de"
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      @file = UploadedFile.new(filename: "LICENSE", data: @data, allowsUpload: @lecture, isLink: true, author: @lecturer)
      sign_in @lecturer
    end

    it "can be saved" do
      expect(@file.save).to be_truthy
    end

    it "is rendered as link" do
      @file.save
      visit course_lecture_uploaded_files_path(@lecture.course, @lecture)
      expect(page).to have_link(@data)
    end
  end
end
