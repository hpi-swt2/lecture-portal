class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]
  before_action :get_lecture
  before_action :set_current_user

  # GET /polls
  def index
    @polls = @lecture.polls
  end

  # GET /polls/1
  def show
  end

  # GET /polls/new
  def new
    if current_user.is_student
      redirect_to lecture_path(@lecture), notice: "You are a student. You can not create polls."
    else
      @poll = @lecture.polls.build
    end
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls
  def create
    current_poll_params = poll_params
    @poll = @lecture.polls.build(title: current_poll_params[:title], is_multiselect: current_poll_params[:is_multiselect], is_active: current_poll_params[:is_active])
    poll_options = current_poll_params[:poll_options]
    for poll_option in poll_options do
      poll_option_description = poll_option.values_at(1)
      new_poll_option = @poll.poll_options.build(description: poll_option_description.to_param)
    end
    if @poll.save
      redirect_to lecture_polls_path(@lecture), notice: "Poll was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /polls/1
  def update
    if @poll.update(poll_params)
      redirect_to lecture_polls_path(@lecture), notice: "Poll was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /polls/1
  def destroy
    @poll.destroy
    redirect_to lecture_polls_path(@lecture), notice: "Poll was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def poll_params
      params.require(:poll).permit(:title, :is_multiselect, :lecture_id, :is_active, :number_of_options, poll_options: params[:poll][:poll_options].keys)
    end

    def get_lecture
      @lecture = Lecture.find(params[:lecture_id])
    end

    def set_current_user
      return unless session[:user_id]
      @current_user ||= User.find(session[:user_id])
      end
end
