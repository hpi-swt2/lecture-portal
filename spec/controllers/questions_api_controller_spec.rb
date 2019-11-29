require 'rails_helper'

RSpec.describe QuestionsApiController, type: :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  context "with user not logged in" do
    describe "GET #index" do
      it "should not return questions list" do
        get :index, params: {}, session: valid_session
        expect(response).to_not be_successful
      end
    end
  end
  
  context "with user logged in" do
    before(:each) do
      # TODO: add student!
      @user = FactoryBot.create(:user)
      sign_in(@user, scope: :user)        
    end

    describe "GET #index" do
      it "should return successful response" do
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end      
      it "should return valid json" do
        @expected = [].to_json
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(@expected)
      end
      it "should return list of all questions" do
        @question = FactoryBot.create(:question, :author => @user)
        
        serialized_question = ActiveModelSerializers::Adapter::Json.new(
          QuestionSerializer.new(@question)
        ).serializable_hash
        @expected = [ serialized_question ].to_json
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(@expected)
      end
    end
    
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Question" do
        expect {
          post :create, params: {question: valid_attributes}, session: valid_session
        }.to change(Question, :count).by(1)
      end

      it "redirects to the created question" do
        post :create, params: {question: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Question.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {question: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

end
