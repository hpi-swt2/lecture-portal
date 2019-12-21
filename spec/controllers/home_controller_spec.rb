require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #join_course" do
    before(:each) do
      # login user
      @course = FactoryBot.create(:course)
    end

    it "redirects to the lectures overview for students" do
      login_student
      post :join_course, params: { id: @course.id }
      expect(response).to redirect_to(@course)
    end
  end

  def login_student(user = FactoryBot.create(:user, :student))
    sign_in(user, scope: :user)
  end
end
