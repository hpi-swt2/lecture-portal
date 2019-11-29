require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:valid_session) { {} }

  describe "GET #index" do
    context "with user not logged in" do
      it "redirects to login screen" do
        get :index, params: {}, session: valid_session
        expect(response).to redirect_to new_user_session_path
      end
    end
    
    context "with user logged in" do
      it "returns a success response" do
        # TODO: add student!
        user = FactoryBot.create(:user)
        sign_in(user, scope: :user)        
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

end
