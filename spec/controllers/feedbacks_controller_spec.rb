require "rails_helper"

RSpec.describe FeedbacksController, type: :controller do
  let(:valid_session) { {} }

  before(:each) do
    @lecturer = FactoryBot.create(:user, :lecturer, email: "lecturer@mail.de")
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    @student = FactoryBot.create(:user, :student)
    sign_in(@student, scope: :user)
    @lecture.join_lecture(@student)
  end

  context "with user logged in as student" do
    describe "CREATE action" do
      it "redirects to course overview when the lecture does not exist", :logged_lecturer do
          not_existing_lecture_id = @lecture.id + 5
          get :create, params: { course_id: (@lecture.course.id), lecture_id: not_existing_lecture_id }, session: valid_session
          expect(response).to redirect_to(course_path(@lecture.course))
        end

      it "redirects to the root path view if the course does not exist", :logged_lecturer do
        not_existing_lecture_id = @lecture.id + 5
        not_existing_course_id = @lecture.course.id + 5
        get :create, params: { course_id: not_existing_course_id, lecture_id: not_existing_lecture_id }, session: valid_session
        expect(response).to redirect_to(root_path)
      end

      it "reloads lecture view when feedback is given when not enabled anymore" do
        @lecture.update(feedback_enabled: false)
        get :create, params: { course_id: @lecture.course.id, lecture_id: @lecture }, session: valid_session
        expect(response).to redirect_to(course_lecture_path(@lecture.course, @lecture))
      end
    end
  end
end
