require "rails_helper"

RSpec.describe FileController, type: :controller do
  before :each do
    @file = fixture_file_upload("files/LICENSE", "text/plain")
    @lecturer = FactoryBot.create(:user, :lecturer)
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    sign_in @lecturer
  end
  it "returns success" do
      file = Hash.new
      file["datafile"] = @file
      file["lecture"] = @lecture.id
      post :upload, params: file
      expect(response).to be_successful
    end

  it "stores the file" do
    old_count = UploadedFile.count
    file = Hash.new
    file["datafile"] = @file
    file["lecture"] = @lecture.id
    post :upload, params: file
    expect(response).to be_successful
    expect(UploadedFile.count).to eq(old_count + 1)
  end

  it "requires authentication" do
    sign_out @lecturer
    old_count = UploadedFile.count
    file = Hash.new
    file["datafile"] = @file
    file["lecture"] = @lecture.id
    post :upload, params: file
    expect(response).to_not be_successful
    expect(UploadedFile.count).to eq(old_count)
  end

  it "stores the file only if lecture provided" do
      old_count = UploadedFile.count
      file = Hash.new
      file["datafile"] = @file
      post :upload, params: file
      expect(response).to_not be_successful
      expect(UploadedFile.count).to eq(old_count)
    end

  it "stores the file only if valid lecture provided" do
    old_count = UploadedFile.count
    file = Hash.new
    file["datafile"] = @file
    file["lecture"] = -1
    post :upload, params: file
    expect(response).to_not be_successful
    expect(UploadedFile.count).to eq(old_count)
  end

  it "stores the file only if valid file provided" do
    old_count = UploadedFile.count
    file = Hash.new
    file["lecture"] = @lecture.id
    post :upload, params: file
    expect(response).to_not be_successful
    expect(UploadedFile.count).to eq(old_count)
  end
end
