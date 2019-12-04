require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe PollsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Poll. As you add validations to Poll, be sure to
  # adjust the attributes here as well.
  let(:lecture) {
    FactoryBot.create(:lecture)
  }
  let(:poll_options_params) {
    {option_1: "", option_2: ""}
  }
  let(:poll_options) {
    [PollOption.new(id: 1, description: ""), PollOption.new(id: 2, description: "")]
  }
  let(:valid_attributes) { {
    title: "Example Title",
    is_multiselect: true,
    lecture_id: lecture.id,
    is_active: false,
    poll_options: poll_options
  }}
  # we need the distinction between params and attributes because
  # we use a react component to dynamically generate the options
  # from input
  let(:valid_params) { {
      title: "Example Title",
      is_multiselect: true,
      lecture_id: lecture.id,
      is_active: false,
      poll_options: poll_options_params
  }}
  let(:invalid_attributes) { {
      title: nil,
      is_multiselect: nil
  }}
  let(:invalid_params) { {
      title: nil,
      is_multiselect: nil,
      poll_options: poll_options_params
  }}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PollsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Poll.create! valid_attributes
      get :index, params: { lecture_id: lecture.id }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      poll = Poll.create! valid_attributes
      get :show, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      login_lecturer
      get :new, params: { lecture_id: lecture.id }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      login_lecturer
      poll = Poll.create! valid_attributes
      get :edit, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Poll" do
        expect {
          post :create, params: { lecture_id: lecture.id, poll: valid_params }, session: valid_session
        }.to change(Poll, :count).by(1)
      end

      it "redirects to the lecture's poll index" do
        post :create, params: { lecture_id: lecture.id, poll: valid_params }, session: valid_session
        expect(response).to redirect_to(lecture_polls_path(lecture))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { lecture_id: lecture.id, poll: invalid_params }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { {
        # skip("Add a hash of attributes valid for your model")
        title: "New Title",
        is_multiselect: false,
        is_active: false,
        poll_options: poll_options_params
      }}

      it "updates the requested poll" do
        poll = Poll.create! valid_attributes
        put :update, params: { lecture_id: lecture.id, id: poll.to_param, poll: new_attributes }, session: valid_session
        poll.reload
        expect(poll.title).to eql(new_attributes[:title])
        expect(poll.is_multiselect).to eql(new_attributes[:is_multiselect])
      end

      it "redirects to the lecture's poll index" do
        poll = Poll.create! valid_attributes
        put :update, params: { lecture_id: lecture.id, id: poll.to_param, poll: valid_params }, session: valid_session
        expect(response).to redirect_to(lecture_polls_path(lecture))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        poll = Poll.create! valid_attributes
        put :update, params: { lecture_id: lecture.id, id: poll.to_param, poll: invalid_params }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested poll" do
      poll = Poll.create! valid_attributes
      expect {
        delete :destroy, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      }.to change(Poll, :count).by(-1)
    end

    it "redirects to the polls list" do
      poll = Poll.create! valid_attributes
      delete :destroy, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      expect(response).to redirect_to(lecture_polls_path(lecture))
    end
  end

  def login_lecturer
    user = FactoryBot.create(:user, :lecturer)
    sign_in(user, scope: :user)
  end
end
