require "rails_helper"

RSpec.describe UploadedFilesController, type: :controller do
  before :each do
    file = fixture_file_upload("files/LICENSE", "text/plain")
    @lecturer = FactoryBot.create(:user, :lecturer)
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    @file = Hash.new
    @file["uploaded_file"] = Hash.new
    @file["uploaded_file"]["attachment"] = file
    @file["uploaded_file"]["lecture"] = @lecture.id
    @file["uploaded_file"]["uploadedFileType"] = "Notes"
    sign_in @lecturer
  end
  it "returns success" do
    post :create, params: @file
    expect(response).to redirect_to(uploaded_files_url)
  end

  it "stores the file" do
    old_count = UploadedFile.count
    post :create, params: @file
    expect(response).to redirect_to(uploaded_files_url)
    expect(UploadedFile.count).to eq(old_count + 1)
  end

  it "requires authentication" do
    sign_out @lecturer
    old_count = UploadedFile.count
    post :create, params: @file
    expect(response).to_not redirect_to(uploaded_files_url)
    expect(UploadedFile.count).to eq(old_count)
  end

  it "stores the file only if lecture provided" do
    old_count = UploadedFile.count
    @file["uploaded_file"].except!("lecture")
    post :create, params: @file
    expect(response).to_not redirect_to(uploaded_files_url)
    expect(UploadedFile.count).to eq(old_count)
  end

  it "stores the file only if valid lecture provided" do
    old_count = UploadedFile.count
    @file["uploaded_file"]["lecture"] = -1
    post :create, params: @file
    expect(response).to_not redirect_to(uploaded_files_url)
    expect(UploadedFile.count).to eq(old_count)
  end

  it "stores the file only if valid file provided" do
        old_count = UploadedFile.count
        @file["uploaded_file"].except!("attachment")
        post :create, params: @file
        expect(response).to_not redirect_to(uploaded_files_url)
        expect(UploadedFile.count).to eq(old_count)
      end

  it "stores files with the Notes category" do
        @file["uploaded_file"]["uploadedFileType"] = "Notes"
        post :create, params: @file
        expect(UploadedFile.find(1).Notes?).to eq(true)
      end

  it "stores files with the Summary category" do
        @file["uploaded_file"]["uploadedFileType"] = "Summary"
        post :create, params: @file
        expect(UploadedFile.find(1).Summary?).to eq(true)
      end
  it "stores files with the Lecture_Slides category" do
        @file["uploaded_file"]["uploadedFileType"] = "Lecture_Slides"
        post :create, params: @file
        expect(UploadedFile.find(1).Lecture_Slides?).to eq(true)
      end
  it "stores files with the Lecture_Material category" do
    @file["uploaded_file"]["uploadedFileType"] = "Lecture_Material"
    post :create, params: @file
    expect(UploadedFile.find(1).Lecture_Material?).to eq(true)
  end
  it "wont't accept a file without category" do
    @file["uploaded_file"].except!("uploadedFileType")
    post :create, params: @file
    expect(response).to_not redirect_to(uploaded_files_url)
  end
end
