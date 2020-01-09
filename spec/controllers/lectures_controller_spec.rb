require "rails_helper"

RSpec.describe LecturesController, type: :controller do
  let(:valid_attributes) {
    { name: "SWT", enrollment_key: "swt", status: "created", questions_enabled: true, polls_enabled: true }
  }
  let(:valid_attributes_with_lecturer) {
    valid_attributes.merge(lecturer: FactoryBot.create(:user, :lecturer, email: "test@test.de"))
  }
  let(:valid_attributes_with_lecturer_with_course) {
    valid_attributes_with_lecturer.merge(course: FactoryBot.create(:course),)
  }
  let(:invalid_attributes) {
    { name: "", enrollment_key: "swt", status: "created" }
  }
  let(:valid_session) { {} }

  before(:each) do |test|
    if test.metadata[:logged_student]
      login_student
    end

    if test.metadata[:logged_lecturer]
      login_lecturer
    end
  end

  describe "Should prompt the user to log in first and redirect before accessing" do
    @lecture = FactoryBot.create(:lecture)
    urls = {
        index: { course_id: @lecture.course.id },
        show: { course_id: @lecture.course.id, id: @lecture.to_param },
        new: { course_id: @lecture.course.id },
        edit: { course_id: @lecture.course.id, id: @lecture.to_param }
    }
    urls.each do |path, params|
      it " the #{path}  page" do
        get path, params: params,  session: valid_session
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #show" do
    it "returns a success response for owner", :logged_lecturer do
      lecture = Lecture.create! valid_attributes_with_lecturer_with_course
      login_lecturer(lecture.lecturer)
      get :show, params: { course_id: (lecture.course.id), id: lecture.to_param }, session: valid_session
      expect(response).to be_successful
    end

    it "returns a success response for joined students", :logged_lecturer do
      lecture = Lecture.create! valid_attributes_with_lecturer_with_course
      student = FactoryBot.create(:user, :student)
      lecture.join_lecture(student)
      login_student(student)
      get :show, params: { course_id: (lecture.course.id), id: lecture.to_param }, session: valid_session
      expect(response).to be_successful
    end

    it "redirects to course overview for not joined students", :logged_lecturer do
      lecture = Lecture.create! valid_attributes_with_lecturer_with_course
      login_student()
      get :show, params: { course_id: (lecture.course.id), id: lecture.to_param }, session: valid_session
      expect(response).to redirect_to(course_path(lecture.course))
    end

    it "redirects to overview for other lecturers", :logged_lecturer do
      lecture = Lecture.create! valid_attributes_with_lecturer_with_course
      login_lecturer()
      get :show, params: { course_id: (lecture.course.id), id: lecture.to_param }, session: valid_session
      expect(response).to redirect_to(course_path(lecture.course))
    end
  end

  describe "GET #new" do
    it "will redirect student to the course path" do
      course = FactoryBot.create(:course)
      login_student
      get :new, params: { course_id: (course.id) }, session: valid_session
      expect(response).to redirect_to(course_path(id: (course.id)))
    end
    it "returns a success response for lecturer", :logged_lecturer do
      course = FactoryBot.create(:course)
      get :new, params: { course_id: (course.id) }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response for lecturer" do
      lecture = Lecture.create! valid_attributes_with_lecturer_with_course
      login_lecturer(lecture.lecturer)
      get :edit, params: { course_id: (lecture.course.id), id: lecture.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Lecture", :logged_lecturer do
        course = FactoryBot.create(:course)
        expect {
          post :create, params: { course_id: (course.id), lecture: valid_attributes }, session: valid_session
        }.to change(Lecture, :count).by(1)
      end

      it "should not create a new Lecture if logged in as student", :logged_student do
        course = FactoryBot.create(:course)
        expect {
          post :create, params: { course_id: (course.id), lecture: valid_attributes }, session: valid_session
        }.to change(Lecture, :count).by(0)
      end

      it "redirects to the lecture dashboard", :logged_lecturer do
        course = FactoryBot.create(:course)
        post :create, params: { course_id: (course.id), lecture: valid_attributes }, session: valid_session
        expect(response).to redirect_to(course_lecture_path(course_id: course.id, id: Lecture.find_by(course_id: course.id).id))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)", :logged_lecturer do
        course = FactoryBot.create(:course)
        post :create, params: { course_id: (course.id), lecture: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "SWT2", enrollment_key: "epic", status: "running" }
      }
      before(:each) do
        @lecture = Lecture.create! valid_attributes_with_lecturer_with_course
        login_lecturer(@lecture.lecturer)
      end

      it "updates the requested lecture" do
        put :update, params: { course_id: @lecture.course.id, id: @lecture.to_param, lecture: new_attributes }, session: valid_session
        @lecture.reload
        expect(@lecture.name).to eq("SWT2")
        expect(@lecture.enrollment_key).to eq("epic")
        expect(@lecture.running?).to eq(true)
        expect(@lecture.status).to eq("running")
      end

      it "redirects to the lecture" do
        put :update, params: { course_id: @lecture.course.id, id: @lecture.to_param, lecture: valid_attributes }, session: valid_session
        expect(response).to redirect_to(course_lecture_path(@lecture.course.id, @lecture))
      end
    end

    context "with invalid params" do
      it "redirects to root for other lecturers", :logged_lecturer do
        lecture = Lecture.create! valid_attributes_with_lecturer_with_course
        put :update, params: { course_id: lecture.course.id, id: lecture.to_param, lecture: invalid_attributes }, session: valid_session
        expect(response).to redirect_to(root_path)
      end
      it "returns a success response for lecturer (i.e. to display the 'edit' template)", :logged_lecturer do
        lecture = Lecture.create! valid_attributes_with_lecturer_with_course
        login_lecturer(lecture.lecturer)
        put :update, params: { course_id: lecture.course.id, id: lecture.to_param, lecture: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do

      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      sign_in(@lecturer, scope: :user)
    end
    it "destroys the requested lecture" do
      expect {
        delete :destroy, params: { course_id: @lecture.course.id, id: @lecture.to_param }, session: valid_session
      }.to change(Lecture, :count).by(-1)
    end

    it "redirects to the lectures list" do
      delete :destroy, params: { course_id: @lecture.course.id, id: @lecture.to_param }, session: valid_session
      expect(response).to redirect_to(course_path)
    end
  end

  describe "POST #join_lecture" do
    before(:each) do

      @lecture = FactoryBot.create(:lecture, status: "running")
    end

    it "redirects to the lectures overview for students" do
      login_student
      post :join_lecture, params: { course_id: @lecture.course.id, id: @lecture.id }, session: valid_session
      expect(response).to redirect_to(course_lecture_path(@lecture.course.id, @lecture))
    end

    it "redirects to overview for other lecturers" do
      login_lecturer
      post :join_lecture, params: { course_id: @lecture.course.id, id: @lecture.id }, session: valid_session
      expect(response).to redirect_to(course_path(@lecture.course.id))
    end
  end

  def login_student(user = FactoryBot.create(:user, :student))
    sign_in(user, scope: :user)
  end
  def login_lecturer(user = FactoryBot.create(:user, :lecturer))
    sign_in(user, scope: :user)
  end
end
