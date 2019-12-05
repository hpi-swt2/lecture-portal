require "rails_helper"

RSpec.describe LecturesController, type: :controller do
  let(:valid_attributes) {
    { name: "SWT", enrollment_key: "swt", status: "created", questions_enabled: true, polls_enabled: true }
  }
  let(:valid_attributes_with_lecturer) {
    valid_attributes.merge(lecturer: FactoryBot.create(:user, :lecturer, email: "test@test.de"))
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

  describe "GET #index" do
    it "returns a success response", :logged_lecturer do
      Lecture.create! valid_attributes_with_lecturer
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response", :logged_lecturer do
      lecture = Lecture.create! valid_attributes_with_lecturer
      get :show, params: { id: lecture.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "does not redirect for student", :logged_student do
      get :new, params: {}, session: valid_session
      expect(response).to redirect_to(lectures_url)
    end
    it "returns a success response for lecturer", :logged_lecturer do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response for lecturer" do
      lecture = Lecture.create! valid_attributes_with_lecturer
      login_lecturer(lecture.lecturer)
      get :edit, params: { id: lecture.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Lecture", :logged_lecturer do
        expect {
          post :create, params: { lecture: valid_attributes }, session: valid_session
        }.to change(Lecture, :count).by(1)
      end

      it "redirects to the created lecture", :logged_lecturer do
        post :create, params: { lecture: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Lecture.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)", :logged_lecturer do
        post :create, params: { lecture: invalid_attributes }, session: valid_session
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
        @lecture = Lecture.create! valid_attributes_with_lecturer
        # login lecturer
        login_lecturer(@lecture.lecturer)
      end

      it "updates the requested lecture" do
        put :update, params: { id: @lecture.to_param, lecture: new_attributes }, session: valid_session
        @lecture.reload
        expect(@lecture.name).to eq("SWT2")
        expect(@lecture.enrollment_key).to eq("epic")
        expect(@lecture.running?).to eq(true)
        expect(@lecture.status).to eq("running")
      end

      it "redirects to the lecture" do
        put :update, params: { id: @lecture.to_param, lecture: valid_attributes }, session: valid_session
        expect(response).to redirect_to(@lecture)
      end
    end

    context "with invalid params" do
      it "redirects for other lecturers", :logged_lecturer do
        lecture = Lecture.create! valid_attributes_with_lecturer
        put :update, params: { id: lecture.to_param, lecture: invalid_attributes }, session: valid_session
        expect(response).to redirect_to(lectures_url)
      end
      it "returns a success response for lecturer (i.e. to display the 'edit' template)", :logged_lecturer do
        lecture = Lecture.create! valid_attributes_with_lecturer
        login_lecturer(lecture.lecturer)
        put :update, params: { id: lecture.to_param, lecture: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      login_lecturer
    end
    it "destroys the requested lecture" do
      lecture = Lecture.create! valid_attributes_with_lecturer
      expect {
        delete :destroy, params: { id: lecture.to_param }, session: valid_session
      }.to change(Lecture, :count).by(-1)
    end

    it "redirects to the lectures list" do
      lecture = Lecture.create! valid_attributes_with_lecturer
      delete :destroy, params: { id: lecture.to_param }, session: valid_session
      expect(response).to redirect_to(lectures_url)
    end
  end

  def login_student(user = FactoryBot.create(:user, :student))
    sign_in(user, scope: :user)
  end
  def login_lecturer(user = FactoryBot.create(:user, :lecturer))
    sign_in(user, scope: :user)
  end
end
