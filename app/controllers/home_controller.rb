class HomeController < ApplicationController
  def index
    @current_user = current_user
    @courses = Course.where(creator: current_user)
    unless current_user.nil?
      @participating_courses = current_user.participating_courses
      @open_courses = Course.where(status: "open") - @participating_courses
    end
  end
end
