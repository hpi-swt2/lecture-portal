require "rails_helper"
require "action_cable/testing/rspec"

RSpec.describe LecturesController, type: :controller do
  let(:valid_attributes) {
    { name: "SWT", enrollment_key: "swt", status: "created", date: "2020-02-02", start_time: "2020-01-01 10:10:00", end_time: "2020-01-01 10:20:00", questions_enabled: true, polls_enabled: true }
  }
  let(:valid_attributes_with_description) {
    { name: "SWT", enrollment_key: "swt", status: "created", date: "2020-02-02", start_time: "2020-01-01 10:10:00", end_time: "2020-01-01 10:20:00", questions_enabled: true, polls_enabled: true, description: "description" }
  }
  let(:valid_attributes_with_lecturer) {
    valid_attributes.merge(lecturer: FactoryBot.create(:user, :lecturer, email: "test@test.de"))
  }
  let(:valid_attributes_with_lecturer_with_course) {
    valid_attributes_with_lecturer.merge(course: FactoryBot.create(:course))
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
        get path, params: params, session: valid_session
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
      # lecture = FactoryBot.create(:lecture, valid_attributes_with_lecturer)
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
      course = FactoryBot.create(:course, creator: @lecturer)
      get :new, params: { course_id: (course.id) }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    describe "is only accessible before a lecture was started:" do
      it "running lecture redirects to overview" do
        lecture = Lecture.create! valid_attributes_with_lecturer_with_course.merge(status: "running")
        login_lecturer(lecture.lecturer)
        get :edit, params: { course_id: (lecture.course.id), id: lecture.to_param }, session: valid_session
        expect(response).to redirect_to(course_lecture_path(course_id: lecture.course.id, id: lecture.id))
      end
      it "ended lecture redirects to overview" do
        # lecture = Lecture.create! valid_attributes_with_lecturer.merge(status: "ended")
        # lecture = FactoryBot.create(:lecture, valid_attributes_with_lecturer.merge(status: "ended"))
        lecture = Lecture.create! valid_attributes_with_lecturer_with_course.merge(status: "ended")
        login_lecturer(lecture.lecturer)
        get :edit, params: { course_id: (lecture.course.id), id: lecture.to_param }, session: valid_session
        expect(response).to redirect_to(course_lecture_path(course_id: lecture.course.id, id: lecture.id))
      end
    end
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
        course = FactoryBot.create(:course, creator: @lecturer)
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

      it "creates a new Lecture with description", :logged_lecturer do
        course = FactoryBot.create(:course, creator: @lecturer)
        expect {
          post :create, params: { course_id: (course.id), lecture: valid_attributes_with_description }, session: valid_session
        }.to change(Lecture, :count).by(1)
      end

      it "redirects to the lecture dashboard", :logged_lecturer do
        course = FactoryBot.create(:course, creator: @lecturer)
        post :create, params: { course_id: (course.id), lecture: valid_attributes }, session: valid_session
        expect(response).to redirect_to(course_lecture_path(course_id: course.id, id: Lecture.find_by(course_id: course.id).id))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)", :logged_lecturer do
        course = FactoryBot.create(:course, creator: @lecturer)
        post :create, params: { course_id: (course.id), lecture: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "SWT2", enrollment_key: "epic", status: "running", description: "new description" }
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
        expect(@lecture.description).to eq("new description")
        expect(@lecture.status).to eq("running")
      end

      it "redirects to the lecture" do
        # put :update, params: { id: @lecture.to_param, lecture: valid_attributes }, session: valid_session
        # expect(response).to redirect_to(lecture_path(@lecture))
        put :update, params: { course_id: @lecture.course.id, id: @lecture.to_param, lecture: valid_attributes }, session: valid_session
        expect(response).to redirect_to(course_lecture_path(@lecture.course.id, @lecture))
      end

      it "removes all joined students when adding key to keyless lecture", :logged_lecturer do
        @lecture.update(enrollment_key: nil)
        @lecture.join_lecture(FactoryBot.create(:user, :student))
        put :update, params: { course_id: @lecture.course.id, id: @lecture.to_param, lecture: new_attributes }, session: valid_session
        @lecture.reload
        expect(@lecture.participating_students.length).to eq(0)
      end
    end

    context "with invalid params" do
      it "redirects to course show for other lecturers", :logged_lecturer do
        lecture = Lecture.create! valid_attributes_with_lecturer_with_course
        put :update, params: { course_id: lecture.course.id, id: lecture.to_param, lecture: invalid_attributes }, session: valid_session
        expect(response).to redirect_to(course_path(id: lecture.course.id))
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
      # post :join_lecture, params: { id: @lecture.id }, session: valid_session
      # expect(response).to redirect_to(lecture_path(@lecture))
      post :join_lecture, params: { course_id: @lecture.course.id, id: @lecture.id }, session: valid_session
      expect(response).to redirect_to(course_lecture_path(@lecture.course.id, @lecture))
    end

    it "redirects to overview for other lecturers" do
      login_lecturer
      post :join_lecture, params: { course_id: @lecture.course.id, id: @lecture.id }, session: valid_session
      expect(response).to redirect_to(course_path(@lecture.course.id))
    end
  end

  describe "POST #leave_lecture" do
    before(:each) do
      @lecture = FactoryBot.create(:lecture, status: "running")
      login_student
      post :join_lecture, params: { course_id: @lecture.course.id, id: @lecture.id }, session: valid_session
    end

    it "redirects to the lectures overview" do
      post :leave_lecture, params: { course_id: @lecture.course.id, id: @lecture.id }, session: valid_session
      expect(response).to redirect_to(course_lecture_path(course_id: @lecture.course.id, id: @lecture.id))
    end
  end

  describe "POST #start_lecture" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      sign_in(@lecturer, scope: :user)
    end

    it "should not be possible to restart an ended lecture" do
      @lecture.set_inactive
      @lecture.save
      expect(@lecture.status).to eq "ended"

      post :start_lecture, params: { course_id: @lecture.course.id, id: @lecture.id }, session: valid_session
      @lecture.reload
      expect(@lecture.status).to eq "ended"
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "SWT2", enrollment_key: "epic", status: "running", description: "new description" }
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
        expect(@lecture.description).to eq("new description")
        expect(@lecture.status).to eq("running")
      end

      it "redirects to the lecture" do
        # put :update, params: { id: @lecture.to_param, lecture: valid_attributes }, session: valid_session
        # expect(response).to redirect_to(lecture_path(@lecture))
        put :update, params: { course_id: @lecture.course.id, id: @lecture.to_param, lecture: valid_attributes }, session: valid_session
        expect(response).to redirect_to(course_lecture_path(@lecture.course.id, @lecture))
      end

      it "removes all joined students when adding key to keyless lecture", :logged_lecturer do
        @lecture.update(enrollment_key: nil)
        @lecture.join_lecture(FactoryBot.create(:user, :student))
        put :update, params: { course_id: @lecture.course.id, id: @lecture.to_param, lecture: new_attributes }, session: valid_session
        @lecture.reload
        expect(@lecture.participating_students.length).to eq(0)
      end
    end

    context "with invalid params" do
      it "redirects to course show for other lecturers", :logged_lecturer do
        lecture = Lecture.create! valid_attributes_with_lecturer_with_course
        put :update, params: { course_id: lecture.course.id, id: lecture.to_param, lecture: invalid_attributes }, session: valid_session
        expect(response).to redirect_to(course_path(id: lecture.course.id))
      end
      it "returns a success response for lecturer (i.e. to display the 'edit' template)", :logged_lecturer do
        lecture = Lecture.create! valid_attributes_with_lecturer_with_course
        login_lecturer(lecture.lecturer)
        put :update, params: { course_id: lecture.course.id, id: lecture.to_param, lecture: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update_comprehension_stamp" do
    before(:each) do
      # login user
      @lecture = FactoryBot.create(:lecture, status: "running")
      @user = FactoryBot.create(:user, :student)
      login_student(@user)
      @lecture.join_lecture(@user)
    end
    context "with valid params" do
      it "adds a comprehension stamp" do
        expect {
          put :update_comprehension_stamp, params: { course_id: (@lecture.course.id), id: @lecture.id, status: 0 }, session: valid_session
        }.to change(LectureComprehensionStamp, :count).by(1)
      end
      it "changes a comprehension stamp" do
        expect {
          put :update_comprehension_stamp, params: { course_id: (@lecture.course.id), id: @lecture.id, status: 0 }, session: valid_session
        }.to change(LectureComprehensionStamp, :count).by(1)
        expect {
          put :update_comprehension_stamp, params: { course_id: (@lecture.course.id), id: @lecture.id, status: 1 }, session: valid_session
        }.to change(LectureComprehensionStamp, :count).by(0)
      end

      it "broadcasts an update to the user" do
        expect {
          put :update_comprehension_stamp, params: { course_id: (@lecture.course.id), id: @lecture.id, status: 0 }, session: valid_session
        }.to have_broadcasted_to("lecture_comprehension_stamp:#{@lecture.id}:#{@user.id}").from_channel(ComprehensionStampChannel)
      end
      it "does not broadcast an update to another user" do
        sign_out(@user)
        @user1 = FactoryBot.create(:user, :student)
        login_student(@user1)
        @lecture.join_lecture(@user1)
        expect {
          put :update_comprehension_stamp, params: { course_id: (@lecture.course.id), id: @lecture.id, status: 0 }, session: valid_session
        }.to_not have_broadcasted_to("lecture_comprehension_stamp:#{@lecture.id}:#{@user.id}").from_channel(ComprehensionStampChannel)
      end
      it "broadcasts an update to the lecturer" do
        expect {
          put :update_comprehension_stamp, params: { course_id: (@lecture.course.id), id: @lecture.id, status: 0 }, session: valid_session
        }.to have_broadcasted_to("lecture_comprehension_stamp:#{@lecture.id}").from_channel(ComprehensionStampChannel)
      end
    end
  end

  describe "GET #get_comprehension" do
    before(:each) do
      # login user
      @lecture = FactoryBot.create(:lecture, status: "running")
    end
    context "as student" do
      before(:each) do
        @user = FactoryBot.create(:user, :student)
        login_student(@user)
        @lecture.join_lecture(@user)
      end
      it "returns correct comprehension level" do
        stamp = LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture)
        get :get_comprehension, params: { course_id: (@lecture.course.id), id: @lecture.id }, session: valid_session
        expect(response.body).to eq({ status: stamp.status, last_update: stamp.timestamp }.to_json)
      end
      it "returns empty comprehension level" do
        get :get_comprehension, params: { course_id: (@lecture.course.id), id: @lecture.id }, session: valid_session
        expect(response.body).to eq({ status: -1, last_update: nil }.to_json)
      end

      it "returns empty comprehension level if too old" do
        stamp = LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture, updated_at: Time.now - LectureComprehensionStamp.seconds_till_comp_timeout)
        get :get_comprehension, params: { course_id: (@lecture.course.id), id: @lecture.id }, session: valid_session
        expect(response.body).to eq({ status: -1, last_update: stamp.timestamp }.to_json)
      end
    end

    context "as lecturer", :logged_lecturer do
      before(:each) do
        @lecture = Lecture.create! valid_attributes_with_lecturer_with_course
        @user = FactoryBot.create(:user, :student)
        login_lecturer(@lecture.lecturer)
      end
      it "returns correct comprehension level" do
        stamp = LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture)
        get :get_comprehension, params: { course_id: (@lecture.course.id), id: @lecture.id }, session: valid_session
        expect(response.body).to eq({ status: [1, 0, 0], last_update: stamp.timestamp }.to_json)
      end
      it "returns correct comprehension level distribution" do
        LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture)
        LectureComprehensionStamp.create(user: FactoryBot.create(:user, :student), status: 1, lecture: @lecture)
        LectureComprehensionStamp.create(user: FactoryBot.create(:user, :student), status: 2, lecture: @lecture)
        stamp_last = LectureComprehensionStamp.create(user: FactoryBot.create(:user, :student), status: 0, lecture: @lecture)
        get :get_comprehension, params: { course_id: (@lecture.course.id), id: @lecture.id }, session: valid_session
        expect(response.body).to eq({ status: [2, 1, 1], last_update: stamp_last.timestamp }.to_json)
      end
      it "returns empty comprehension level" do
        get :get_comprehension, params: { course_id: (@lecture.course.id), id: @lecture.id }, session: valid_session
        expect(response.body).to eq({ status: [0, 0, 0], last_update: nil }.to_json)
      end

      it "returns empty comprehension level if too old" do
        stamp = LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture, updated_at: Time.now - LectureComprehensionStamp.seconds_till_comp_timeout)
        get :get_comprehension, params: { course_id: (@lecture.course.id), id: @lecture.id }, session: valid_session
        expect(response.body).to eq({ status: [0, 0, 0], last_update: stamp.timestamp }.to_json)
      end
    end
  end

  def login_student(user = FactoryBot.create(:user, :student))
    sign_in(user, scope: :user)
  end
  def login_lecturer(user = FactoryBot.create(:user, :lecturer))
    @lecturer = user
    sign_in(user, scope: :user)
  end
end
