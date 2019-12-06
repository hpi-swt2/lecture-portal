require "rails_helper"
require "action_cable/testing/rspec"

RSpec.describe Api::QuestionsController, type: :controller do
  let(:valid_attributes) {
    { content: "Question" }
  }
  let(:invalid_attributes) {
    { content: "" }
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

  context "with user logged in as student" do
    before(:each) do
      @student = FactoryBot.create(:user, :student)
      sign_in(@student, scope: :user)
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
        question = FactoryBot.create(:question, author: @student)
        expected = [ QuestionSerializer.new(question).as_json ]
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end
      it "should return a time-sorted list of all questions" do
        question1 = FactoryBot.create(:question, author: @student)
        question2 = FactoryBot.create(:question, author: @student)
        expected = [ QuestionSerializer.new(question2).as_json,
                      QuestionSerializer.new(question1).as_json ]
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end
    end

    describe "POST #upvote" do
      it "should set the user as an upvoter for the question" do
        question = FactoryBot.create(:question)
        post :upvote, params: { id: question.id }, session: valid_session
        updatedQuestion = Question.find(question.id)
        expect(updatedQuestion.upvoters).to include(@student)
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
          expect(created_question.author).to eq(@student)
        end
        it "broadcasts a question after creation" do
          expect {
            post :create, params: valid_attributes, session: valid_session
          }.to have_broadcasted_to("questions_channel")
        end
      end
    end
  end

  context "with user logged in as lecturer" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      sign_in(@lecturer, scope: :user)
    end

    describe "POST #create" do
      it "does not create a question" do
        expect {
          post :create, params: valid_attributes, session: valid_session
        }.to change(Question, :count).by(0)
      end
    end
  end
end
