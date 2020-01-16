class CalendarsController < ActionController::Base
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]

  # GET /calendars
  def index
    @calendars = Calendar.all
  end

  # GET /calendars/1
  def show
    cal = Icalendar::Calendar.new
    cal.x_wr_calname = 'Awesome Rails Calendar'
    cal.event do |e|
      e.dtstart     = DateTime.now + 2.hours
      e.dtend       = DateTime.now + 3.hours
      e.summary     = 'Power Lunch'
      e.description = 'Get together and do big things'
    end
    cal.publish
    render plain: cal.to_ical
  end


  # GET /calendars/new
  def new
    @calendar = Calendar.new
  end

  # GET /calendars/1/edit
  def edit
  end

  # POST /calendars
  def create
    @calendar = Calendar.new(calendar_params)

    if @calendar.save
      redirect_to @calendar, notice: 'Calendar was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /calendars/1
  def update
    if @calendar.update(calendar_params)
      redirect_to @calendar, notice: 'Calendar was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /calendars/1
  def destroy
    @calendar.destroy
    redirect_to calendars_url, notice: 'Calendar was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def calendar_params
      params.require(:calendar).permit(:ical)
    end
end
