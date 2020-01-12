require "rails_helper"

describe "The uploaded files index page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "having uploaded one file" do
    before :each do
      data = file_fixture("LICENSE").read
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      @file = UploadedFile.new(filename: "LICENSE", content_type: "text/plain", data: data, allowsUpload: @lecture, author: @lecturer)
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
      fileAuthor = @file.author
      expect(fileAuthor.uploaded_files.include?(@file)).to be_truthy
    end

    it "should show the license content type" do
      visit uploaded_files_path
      # setup worked, else rest of test is pointless
      expect(UploadedFile.all.size).to eq(1)
      expect(find(:table_row, { "Filename" => "LICENSE" }, {})).to have_text("text/plain")
    end

    it "should show the license text" do
      visit uploaded_files_path
      # setup worked, else rest of test is pointless
      expect(UploadedFile.all.size).to eq(1)
      expect(find(:table_row, { "Filename" => "LICENSE" }, {})).to have_text("WITHOUT WARRANTY OF ANY KIND")
    end

    it "should show a download link" do
      visit uploaded_files_path
      expect(page).to have_link "Download", href: uploaded_file_path(@file), count: 1
    end

    it "should download the file when clicking the link" do
      visit uploaded_files_path
      click_on "Download"
      expect(page.body).to eql @file.data
      expect(page.response_headers["Content-Type"]).to eql @file.content_type
    end
  end
end
