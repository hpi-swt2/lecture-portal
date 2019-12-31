class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]
  before_action :get_lecture
  before_action :authenticate_user!

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
      redirect_to lecture_polls_path(@lecture), notice: "You are a student. You cannot create polls."
    else
      @poll = @lecture.polls.build
    end
  end

  # GET /polls/1/edit
  def edit
    if current_user.is_student
      broadcast_options
      render :answer
    end
  end

  def save_answers
    puts(params)
    broadcast_options
    redirect_to lecture_poll_path(@lecture, params[:id])
  end

  # POST /polls
  def create
    current_poll_params = poll_params
    @poll = @lecture.polls.build(title: current_poll_params[:title], is_multiselect: current_poll_params[:is_multiselect], is_active: current_poll_params[:is_active])
    poll_options = current_poll_params[:poll_options]
    for poll_option in poll_options do
      poll_option_description = poll_option.values_at(1)
      @poll.poll_options.build(description: poll_option_description.to_param)
    end
    if @poll.save
      redirect_to lecture_polls_path(@lecture), notice: "Poll was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /polls/1
  def update
    current_poll_params = poll_params
    if @poll.update(title: current_poll_params[:title], is_multiselect: current_poll_params[:is_multiselect], is_active: current_poll_params[:is_active])
      # Remove all previously existing options so there are no conflicts with the new/updated ones.
      PollOption.where(poll_id: @poll.id).destroy_all
      poll_options = current_poll_params[:poll_options]
      for poll_option in poll_options do
        poll_option_description = poll_option.values_at(1)
        @poll.poll_options.build(description: poll_option_description.to_param)
      end
      if @poll.save
        redirect_to lecture_polls_path(@lecture), notice: "Poll was successfully updated."
      else
        render :edit
      end
    else
      render :edit
    end
    broadcast_options
  end

  # DELETE /polls/1
  def destroy
    @poll.destroy
    broadcast_options
    redirect_to lecture_polls_path(@lecture), notice: "Poll was successfully destroyed."
  end

  # GET /polls/:id/serializedOptions
  def serialized_options
    get_serialized_options
    render json: @poll_options
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

    # Send belonging poll_options to subscribers so they can update their data
    def broadcast_options
      poll = Poll.find(params[:id])
      if poll.lecture == @lecture
        get_serialized_options
        # broadcast update via ActionCable
        PollOptionsChannel.broadcast_to(poll, @serialized_poll_options)
      end
    end

    def get_serialized_options
      poll = Poll.find(params[:id])
      @poll_options = poll.poll_options
      @serialized_poll_options = @poll_options.map{|option| ActiveModelSerializers::Adapter::Json.new(
          PollOptionSerializer.new(option)
      ).serializable_hash}
    end

    def get_lecture
      @lecture = Lecture.find(params[:lecture_id])
    end
end
