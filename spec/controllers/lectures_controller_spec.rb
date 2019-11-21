require "rails_helper"

RSpec.describe LecturesController, type: :controller do
  let(:valid_attributes) {
    { name: "SWT", enrollment_key: "swt", is_running: true }
  }
  let(:invalid_attributes) {
    { name: "", enrollment_key: "swt", is_running: true }
  }
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Lecture.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      lecture = Lecture.create! valid_attributes
      get :show, params: { id: lecture.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      lecture = Lecture.create! valid_attributes
      get :edit, params: { id: lecture.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Lecture" do
        expect {
          post :create, params: { lecture: valid_attributes }, session: valid_session
        }.to change(Lecture, :count).by(1)
      end

      it "redirects to the created lecture" do
        post :create, params: { lecture: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Lecture.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { lecture: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "SWT2", enrollment_key: "epic", is_running: false }
      }

      it "updates the requested lecture" do
        lecture = Lecture.create! valid_attributes
        put :update, params: { id: lecture.to_param, lecture: new_attributes }, session: valid_session
        lecture.reload
        expect(lecture.name).to eq("SWT2")
        expect(lecture.enrollment_key).to eq("epic")
        expect(lecture.is_running).to eq(false)
      end

      it "redirects to the lecture" do
        lecture = Lecture.create! valid_attributes
        put :update, params: { id: lecture.to_param, lecture: valid_attributes }, session: valid_session
        expect(response).to redirect_to(lecture)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        lecture = Lecture.create! valid_attributes
        put :update, params: { id: lecture.to_param, lecture: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested lecture" do
      lecture = Lecture.create! valid_attributes
      expect {
        delete :destroy, params: { id: lecture.to_param }, session: valid_session
      }.to change(Lecture, :count).by(-1)
    end

    it "redirects to the lectures list" do
      lecture = Lecture.create! valid_attributes
      delete :destroy, params: { id: lecture.to_param }, session: valid_session
      expect(response).to redirect_to(lectures_url)
    end
  end
end
