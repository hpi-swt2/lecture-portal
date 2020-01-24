require "rails_helper"

RSpec.describe Question, type: :model do
  it "is creatable using a Factory" do
    question = FactoryBot.create(:question)
    expect(question).to be_valid
  end

  it "is not valid with an empty content" do
    question = FactoryBot.build(:question, content: "")
    expect(question).to_not be_valid
  end

  it "is not valid without an author" do
    question = FactoryBot.build(:question, author: nil)
    expect(question).to_not be_valid
  end

  it "is not valid without a lecture" do
    question = FactoryBot.build(:question, lecture: nil)
    expect(question).to_not be_valid
  end

  it "can have upvoting users" do
    question = FactoryBot.build(:question)
    user1 = FactoryBot.create(:user, :student, email: "test1@hpi.de")
    user2 = FactoryBot.create(:user, :student, email: "test2@hpi.de")
    question.upvoters << user1
    question.upvoters << user2
  end

  describe "questions_for_lecture" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer, email: "lecturer@mail.de")
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    end
    context "with user logged in as student" do
      before(:each) do
        @student = FactoryBot.create(:user, :student)
        @lecture.join_lecture(@student)
        @question = FactoryBot.create(:question, author: @student, lecture: @lecture)
      end

      it "should return list of a question" do
        expected = ActiveModelSerializers::SerializableResource.new(
            [@question],
            each_serializer: QuestionSerializer,
            current_user: @student)
        expect(Question.questions_for_lecture(@lecture, @student).to_json).to eq(expected.to_json)
      end
      it "should return a time-sorted list of all questions" do
        question2 = FactoryBot.create(:question, author: @student, lecture: @lecture)
        expected = ActiveModelSerializers::SerializableResource.new(
            [question2, @question],
            each_serializer: QuestionSerializer,
            current_user: @student)
        expect(Question.questions_for_lecture(@lecture, @student).to_json).to eq(expected.to_json)
      end

      it "should only show questions belonging to the requested lecture" do
        another_lecture = FactoryBot.create(:lecture)
        another_lecture.join_lecture(@student)
        FactoryBot.create(:question, author: @student, lecture: another_lecture)
        expected = ActiveModelSerializers::SerializableResource.new(
            [@question],
            each_serializer: QuestionSerializer,
            current_user: @student)
        expect(Question.questions_for_lecture(@lecture, @student).to_json).to eq(expected.to_json)
      end
    end
  end
end
