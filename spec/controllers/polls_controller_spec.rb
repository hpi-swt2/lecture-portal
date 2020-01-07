require "rails_helper"

RSpec.describe PollsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Poll. As you add validations to Poll, be sure to
  # adjust the attributes here as well.
  let(:lecture) {
    FactoryBot.create(:lecture)
  }
  let(:poll_options_params) {
    { option_1: "", option_2: "" }
  }
  let(:poll_options) {
    [PollOption.new(id: 1, description: ""), PollOption.new(id: 2, description: "")]
  }
  let(:valid_attributes) { {
    title: "Example Title",
    lecture: FactoryBot.create(:lecture),
    is_multiselect: true,
    lecture_id: lecture.id,
    is_active: false,
    poll_options: poll_options
  }}
  let(:valid_attributes_with_active) { {
    title: "Example Title",
    is_multiselect: true,
    lecture_id: lecture.id,
    is_active: true,
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

  before(:each) do |test|
    if test.metadata[:logged_lecturer]
      login_lecturer
    end

    if test.metadata[:logged_student]
      login_student
    end
  end

  describe "Should prompt the user to log in first and redirect before accessing" do
    @lecture = FactoryBot.create(:lecture)
    @poll = FactoryBot.create(:poll)
    urls = {
        index: { lecture_id: @lecture.to_param },
        show: { lecture_id: @lecture.to_param, id: @poll.to_param },
        new: { lecture_id: @lecture.to_param },
        edit: { lecture_id: @lecture.to_param, id: @poll.to_param }
    }
    urls.each do |path, params|
      it " the #{path}  page" do
        get path, params: params,  session: valid_session
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #index" do
    it "returns a success response", :logged_student do
      Poll.create! valid_attributes
      get :index, params: { lecture_id: lecture.id }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response", :logged_lecturer do
      poll = Poll.create! valid_attributes
      get :show, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response for lecturers", :logged_lecturer do
      get :new, params: { lecture_id: lecture.id }, session: valid_session
      expect(response).to be_successful
    end
    it "redirects to lecture poll index for students", :logged_student do
      get :new, params: { lecture_id: lecture.id }, session: valid_session
      expect(response).to redirect_to(lecture_polls_path(lecture))
    end
  end

  describe "GET #edit" do
    it "returns a success response for lecturers", :logged_lecturer do
      poll = Poll.create! valid_attributes
      get :edit, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      expect(response).to be_successful
    end

    it "returns a failure response for students for not active polls", :logged_student do
      poll = Poll.create! valid_attributes
      poll.is_active = false
      get :edit, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      expect(response).not_to be_successful
    end

    it "returns a success response for students for active polls", :logged_student do
      poll = Poll.create! valid_attributes_with_active
      poll.is_active = true
      get :edit, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Poll", :logged_lecturer do
        expect {
          post :create, params: { lecture_id: lecture.id, poll: valid_params }, session: valid_session
        }.to change(Poll, :count).by(1)
      end

      it "redirects to the lecture's poll index", :logged_lecturer do
        post :create, params: { lecture_id: lecture.id, poll: valid_params }, session: valid_session
        expect(response).to redirect_to(lecture_polls_path(lecture))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)", :logged_lecturer do
        post :create, params: { lecture_id: lecture.id, poll: invalid_params }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "#stop_start" do
    it "starts an inactive poll", :logged_student do
      poll = FactoryBot.create(:poll, :inactive)
      get :stop_start, params: { lecture_id: lecture.id, id: poll.id }, session: valid_session
      poll.reload
      expect(poll.is_active).to eq(true)
    end
    it "stops an active poll", :logged_student do
      poll = FactoryBot.create(:poll, :active)
      get :stop_start, params: { lecture_id: lecture.id, id: poll.id }, session: valid_session
      poll.reload
      expect(poll.is_active).to eq(false)
    end
  end

  describe "#save_answers" do
=begin
    Find out, how to send booleans as params so that they are properly appraised.
    Up until now the value is true, but does not evaluate to true when compared
    via == true.

    it "saves answer to active poll", :logged_student do
      poll = FactoryBot.create(:poll, :active)
      poll.update(poll_options: poll_options)
      answers = [{id: poll_options[0].id, :value => true}, {id: poll_options[1].id, :value => false}]
      puts(answers[0].inspect)
      get :save_answers, params: { lecture_id: lecture.id, id: poll.id, answers: answers, poll: valid_params }
      puts(Answer.all)
      expect(Answer.where(poll_id: poll.id, option_id: poll.poll_options[0].id)).to exist
    end
    it "updates votes to option when submitting answer to poll", :logged_student do
      poll = FactoryBot.create(:poll, :active)
      poll.update(poll_options: poll_options)
      answers = [{id: poll_options[0].id, value: true}, {id: poll_options[1].id, value: false}]
      get :save_answers, params: { lecture_id: lecture.id, id: poll.id, answers: answers, poll: valid_params }
      poll.reload
      expect(poll.poll_options[0].votes).to eq(1)
    end

=end
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

      it "updates the requested poll", :logged_lecturer do
        poll = Poll.create! valid_attributes
        put :update, params: { lecture_id: lecture.id, id: poll.to_param, poll: new_attributes }, session: valid_session
        poll.reload
        expect(poll.title).to eql(new_attributes[:title])
        expect(poll.is_multiselect).to eql(new_attributes[:is_multiselect])
      end

      it "redirects to the lecture's poll index", :logged_lecturer do
        poll = Poll.create! valid_attributes
        put :update, params: { lecture_id: lecture.id, id: poll.to_param, poll: valid_params }, session: valid_session
        expect(response).to redirect_to(lecture_polls_path(lecture))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)", :logged_lecturer do
        poll = Poll.create! valid_attributes
        put :update, params: { lecture_id: lecture.id, id: poll.to_param, poll: invalid_params }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested poll", :logged_lecturer do
      poll = Poll.create! valid_attributes
      expect {
        delete :destroy, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      }.to change(Poll, :count).by(-1)
    end

    it "redirects to the polls list", :logged_lecturer do
      poll = Poll.create! valid_attributes
      delete :destroy, params: { lecture_id: lecture.id, id: poll.to_param }, session: valid_session
      expect(response).to redirect_to(lecture_polls_path(lecture))
    end
  end

  def login_lecturer
    user = FactoryBot.create(:user, :lecturer)
    sign_in(user, scope: :user)
  end
  def login_student
    user = FactoryBot.create(:user, :student)
    sign_in(user, scope: :user)
  end
end
