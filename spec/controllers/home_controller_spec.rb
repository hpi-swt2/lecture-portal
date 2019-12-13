require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "returns http success when no user is logged in" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "redirects lecturer to lecture overview" do
      sign_in(FactoryBot.create(:user, :lecturer), scope: :user)
      get :index
      expect(response).to redirect_to(lectures_url)
    end

    it "redirects student to currently active lectures overview" do
      sign_in(FactoryBot.create(:user, :student), scope: :user)
      get :index
      expect(response).to redirect_to(current_lectures_url)
    end
  end
end
