require 'rails_helper'
require "action_cable/testing/rspec"

RSpec.describe QuestionsApiController, type: :controller do

  let(:valid_attributes) {
    {:content => "Question"}
  }

  let(:invalid_attributes) {
    {:content => ""}
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
        expected = [].to_json
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(expected)
      end
      it "should return list of a question" do
        question = FactoryBot.create(:question, :author => @user)
        expected = [ QuestionSerializer.new(question).as_json ]
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end
      it "should return a time-sorted list of all questions" do
        question1 = FactoryBot.create(:question, :author => @user)
        question2 = FactoryBot.create(:question, :author => @user)
        expected = [ QuestionSerializer.new(question2).as_json,
                      QuestionSerializer.new(question1).as_json ]
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end
    end

    describe "POST #create" do
      context "with invalid params" do
        it "does not create a question" do
          expect {
            post :create, params: invalid_attributes, session: valid_session
          }.to change(Question, :count).by(0)
        end
      end
      context "with valid params" do
        it "creates a new question" do
          expect {
            post :create, params: valid_attributes, session: valid_session
          }.to change(Question, :count).by(1)
        end
        it "creates a new question with the currenly logged in user as author" do
          post :create, params: valid_attributes, session: valid_session
          created_question = Question.find(1)
          expect(created_question.author).to eq(@user)
        end
        it "broadcasts a question after creation" do          
          expect { 
            post :create, params: valid_attributes, session: valid_session
          }.to have_broadcasted_to("questions_channel")
        end
      end   
    end
  end
end
