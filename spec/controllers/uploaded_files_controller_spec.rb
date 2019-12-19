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
end
