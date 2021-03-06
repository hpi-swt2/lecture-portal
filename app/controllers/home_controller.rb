class HomeController < ApplicationController
  def index
    @current_user = current_user
    @courses = Course.where(creator: current_user)
    unless current_user.nil?
      @participating_lectures = current_user.participating_lectures
      @participating_courses = current_user.participating_courses
    end
  end
end
