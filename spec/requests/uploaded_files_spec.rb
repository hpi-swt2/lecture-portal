require 'rails_helper'

RSpec.describe "UploadedFiles", type: :request do
  describe "GET /uploaded_files" do
    it "works! (now write some real specs)" do
      get uploaded_files_path
      expect(response).to have_http_status(200)
    end
  end
end
