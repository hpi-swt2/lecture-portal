require "rails_helper"
require "action_cable/testing/rspec"

RSpec.describe QuestionsController, type: :controller do
  let(:valid_session) { {} }

  before(:each) do
    @lecturer = FactoryBot.create(:user, :lecturer, email: "lecturer@mail.de")
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    @valid_attributes = {
      content: "Question",
      lecture_id: @lecture.id,
      course_id: @lecture.course.id
    }
    @invalid_attributes = {
      content: "",
      lecture_id: @lecture.id,
    course_id: @lecture.course.id
    }
  end

  context "with user not logged in" do
    describe "GET #index" do
      it "should not return questions list" do
        get :index, params: { course_id: @lecture.course.id, lecture_id: @lecture.id },  session: valid_session
        expect(response).not_to be_successful
      end
    end
  end

  context "with user logged in as student" do
    before(:each) do
      @student = FactoryBot.create(:user, :student)
      sign_in(@student, scope: :user)
      @lecture.join_lecture(@student)
      @question = FactoryBot.create(:question, author: @student, lecture: @lecture)
    end

    describe "GET #index" do
      it "should return successful response" do
        get :index, params: { course_id: @lecture.course.id, lecture_id: @lecture.id }, session: valid_session
        expect(response).to be_successful
      end
      it "should return list of a question" do
        expected = [ QuestionSerializer.new(@question, scope: @student, scope_name: :current_user).as_json ]
        get :index, params: { course_id: @lecture.course.id, lecture_id: @lecture.id }, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end
      it "should return a time-sorted list of all questions" do
        question2 = FactoryBot.create(:question, author: @student, lecture: @lecture)
        expected = [ QuestionSerializer.new(question2, scope: @student, scope_name: :current_user).as_json,
                     QuestionSerializer.new(@question, scope: @student, scope_name: :current_user).as_json ]
        get :index, params: { course_id: @lecture.course.id, lecture_id: @lecture.id }, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end

      it "should only show unresolved questions" do
        FactoryBot.create(:question, author: @student)
        unresolved_question = FactoryBot.create(:question, author: @student, lecture: @lecture)
        post :resolve, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: @question.id }, session: valid_session
        expected = [ QuestionSerializer.new(unresolved_question, scope: @student, scope_name: :current_user).as_json ]
        get :index, params: { course_id: @lecture.course.id, lecture_id: @lecture.id }, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end

      it "should only show questions belonging to the requested lecture" do
        another_lecture = FactoryBot.create(:lecture)
        another_lecture.join_lecture(@student)
        FactoryBot.create(:question, author: @student, lecture: another_lecture)
        expected = [ QuestionSerializer.new(@question, scope: @student, scope_name: :current_user).as_json ]
        get :index, params: { course_id: @lecture.course.id, lecture_id: @lecture.id }, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end
    end

    describe "POST #upvote" do
      before(:each) do
        other_student = FactoryBot.create(:user, :student)
        @question_by_other_user = FactoryBot.create(:question, author: other_student, lecture: @lecture)
      end
      it "should set the user as an upvoter for the question" do
        post :upvote, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: @question_by_other_user.id }, session: valid_session
        updatedQuestion = Question.find(@question_by_other_user.id)
        expect(updatedQuestion.upvoters).to include(@student)
      end

      it "should not upvote a question if the student is the author" do
        post :upvote, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: @question.id }, session: valid_session
        updatedQuestion = Question.find(@question.id)
        expect(updatedQuestion.upvotes).to eq(0)
      end

      it "should upvote a question if the student is not the author" do
        post :upvote, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: @question_by_other_user.id }, session: valid_session
        updatedQuestion = Question.find(@question_by_other_user.id)
        expect(updatedQuestion.upvotes).to be > 0
      end
    end

    describe "POST #create" do
      context "with invalid params" do
        it "does not create a question" do
          expect {
            post :create, params: @invalid_attributes, session: valid_session
          }.to change(Question, :count).by(0)
        end
      end
      context "with valid params" do
        it "creates a new question" do
          expect {
            post :create, params: @valid_attributes, session: valid_session
          }.to change(Question, :count).by(1)
        end
        it "creates a new question with the currenly logged in user as author" do
          post :create, params: @valid_attributes, session: valid_session
          created_question = Question.find(1)
          expect(created_question.author).to eq(@student)
        end
        it "creates a new question with 'resolved' being set to false as a default" do
          post :create, params: @valid_attributes, session: valid_session
          created_question = Question.find(1)
          expect(created_question.resolved).to eq(false)
        end
        it "broadcasts a question after creation" do
          expect {
            post :create, params: @valid_attributes, session: valid_session
          }.to have_broadcasted_to(@lecture).from_channel(QuestionsChannel)
        end
      end
    end

    describe "POST #resolve" do
      it "should set a question as resolved if the student is the author" do
        post :resolve, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: @question.id }, session: valid_session
        updatedQuestion = Question.find(@question.id)
        expect(updatedQuestion.resolved).to eq(true)
      end

      it "should not set a question as resolved if the student is not the author" do
        other_student = FactoryBot.create(:user, :student)
        question_by_other_user = FactoryBot.create(:question, author: other_student, lecture: @lecture)
        post :resolve, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: question_by_other_user.id }, session: valid_session
        updatedQuestion = Question.find(question_by_other_user.id)
        expect(updatedQuestion.resolved).to eq(false)
      end
    end
  end

  context "with user logged in as lecturer" do
    before(:each) do
      @question = FactoryBot.create(:question, lecture: @lecture)
      sign_in(@lecturer, scope: :user)
    end

    describe "POST #create" do
      it "does not create a question" do
        expect {
          post :create, params: @valid_attributes, session: valid_session
        }.to change(Question, :count).by(0)
      end
    end

    describe "POST #resolve" do
      it "should set a question as resolved after the resolve API call" do
        post :resolve, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: @question.id }, session: valid_session
        puts response.body
        updatedQuestion = Question.find(@question.id)
        expect(updatedQuestion.resolved).to eq(true)
      end

      it "should only show unresolved questions" do
        post :resolve, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: @question.id }, session: valid_session
        get :index, params: { course_id: @lecture.course.id, lecture_id: @lecture.id }, session: valid_session
        expect(response.body).to eq([].to_json)
      end
    end

    describe "POST #upvote" do
      it "should not upvote a question" do
        post :upvote, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: @question.id }, session: valid_session
        updatedQuestion = Question.find(@question.id)
        expect(updatedQuestion.upvotes).to eq(0)
      end

      it "should return a sorted list with upvoted questions first" do
        another_student = FactoryBot.create(:user, :student, email: "student2@mail.de")
        @lecture.join_lecture(another_student)
        not_upvoted_question = FactoryBot.create(:question, author: another_student, lecture: @lecture)
        sign_in(another_student, scope: :user)
        post :upvote, params: { course_id: @lecture.course.id, lecture_id: @lecture.id, id: @question.id }, session: valid_session
        sign_out(another_student)
        sign_in(@lecturer, scope: :user)
        expected = [ QuestionSerializer.new(@question, scope: @lecturer, scope_name: :current_user).as_json,
                     QuestionSerializer.new(not_upvoted_question, scope: @lecturer, scope_name: :current_user).as_json ]
        get :index, params: { course_id: @lecture.course.id, lecture_id: @lecture.id }, session: valid_session
        expect(response.body).to eq(expected.to_json)
      end
    end
  end
end
