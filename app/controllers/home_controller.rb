class HomeController < ApplicationController
  def index
    @current_user = current_user
    @courses = Course.where(creator: current_user)
    @open_courses = Course.where(status: "open")
  end
end
