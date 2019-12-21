class HomeController < ApplicationController
  def index
    @current_user = current_user
    @courses = Course.where(creator: current_user)
    @open_courses = Course.where(status: "open")
  end

  def join_course
    @course = Course.find(params[:id])
    @course.join_course(current_user)
    @course.save
    current_user.save
    redirect_to @course, notice: "You successfully joined the lecture."
  end

end
