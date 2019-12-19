require "rails_helper"
require "action_cable/testing/rspec"

RSpec.describe QuestionsController, type: :controller do
  let(:valid_attributes) {
    { content: "Question" }
  }
  let(:invalid_attributes) {
    { content: "" }
  }
  let(:valid_session) { {} }

  context "with user not logged in" do
    before(:each) do
      @lecture = FactoryBot.create(:lecture)
    end

    describe "GET #index" do
      it "should not return questions list" do
        get :index, params: { lecture_id: @lecture.to_param },  session: valid_session
        expect(response).to not_be_successful
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
        expected = [ QuestionSerializer.new(question, scope: @student, scope_name: :current_user).as_json ]
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end
      it "should return a time-sorted list of all questions" do
        question1 = FactoryBot.create(:question, author: @student)
        question2 = FactoryBot.create(:question, author: @student)
        expected = [ QuestionSerializer.new(question2, scope: @student, scope_name: :current_user).as_json,
                     QuestionSerializer.new(question1, scope: @student, scope_name: :current_user).as_json ]
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end

      it "should only show unresolved questions" do
        FactoryBot.create(:question, author: @student)
        question = FactoryBot.create(:question, author: @student)
        post :resolve, params: { id: 1 }, session: valid_session
        expected = [ QuestionSerializer.new(question, scope: @student, scope_name: :current_user).as_json ]
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

      it "should not upvote a question if the student is the author" do
        question = FactoryBot.create(:question, author: @student)
        post :upvote, params: { id: question.id }, session: valid_session
        updatedQuestion = Question.find(question.id)
        expect(updatedQuestion.upvotes).to eq(0)
      end

      it "should upvote a question if the student is not the author" do
        student2 = FactoryBot.create(:user, :student, email: "student2@mail.de")
        question = FactoryBot.create(:question, author: student2)
        post :upvote, params: { id: question.id }, session: valid_session
        updatedQuestion = Question.find(question.id)
        expect(updatedQuestion.upvotes).to be > 0
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
        it "creates a new question with 'resolved' being set to false as a default" do
          post :create, params: valid_attributes, session: valid_session
          created_question = Question.find(1)
          expect(created_question.resolved).to eq(false)
        end
        it "broadcasts a question after creation" do
          expect {
            post :create, params: valid_attributes, session: valid_session
          }.to have_broadcasted_to("questions_channel")
        end
      end
    end

    describe "POST #resolve" do
      it "should set a question as resolved if the student is the author" do
        question = FactoryBot.create(:question, author: @student)
        post :resolve, params: { id: question.id }, session: valid_session
        updatedQuestion = Question.find(question.id)
        expect(updatedQuestion.resolved).to eq(true)
      end

      it "should not set a question as resolved if the student is not the author" do
        student2 = FactoryBot.create(:user, :student, email: "student2@mail.de")
        question = FactoryBot.create(:question, author: student2)
        post :resolve, params: { id: question.id }, session: valid_session
        updatedQuestion = Question.find(question.id)
        expect(updatedQuestion.resolved).to eq(false)
      end
    end
  end

  context "with user logged in as lecturer" do
    before(:each) do
      @question = FactoryBot.create(:question)
      @lecturer = FactoryBot.create(:user, :lecturer, email: "lecturer@mail.de")
      sign_in(@lecturer, scope: :user)
    end

    describe "POST #create" do
      it "does not create a question" do
        expect {
          post :create, params: valid_attributes, session: valid_session
        }.to change(Question, :count).by(0)
      end
    end

    describe "POST #resolve" do
      it "should set a question as resolved after the resolve API call" do
        post :resolve, params: { id: @question.id }, session: valid_session
        updatedQuestion = Question.find(@question.id)
        expect(updatedQuestion.resolved).to eq(true)
      end

      it "should only show unresolved questions" do
        post :resolve, params: { id: @question.id }, session: valid_session
        get :index, params: {}, session: valid_session
        expect(response.body).to eq([].to_json)
      end
    end

    describe "POST #upvote" do
      it "should not upvote a question" do
        post :upvote, params: { id: @question.id }, session: valid_session
        updatedQuestion = Question.find(@question.id)
        expect(updatedQuestion.upvotes).to eq(0)
      end

      it "should return a sorted list with upvoted questions first" do
        student1 = FactoryBot.create(:user, :student)
        student2 = FactoryBot.create(:user, :student, email: "student2@mail.de")
        question1 = FactoryBot.create(:question, author: student1)
        sign_in(student2, scope: :user)
        post :upvote, params: { id: question1.id }, session: valid_session
        sign_out(student2)
        sign_in(@lecturer, scope: :user)
        expected = [ QuestionSerializer.new(question1, scope: @lecturer, scope_name: :current_user).as_json,
                     QuestionSerializer.new(@question, scope: @lecturer, scope_name: :current_user).as_json ]
        get :index, params: {}, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end
    end
  end
end
