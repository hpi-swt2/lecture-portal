class HomeController < ApplicationController
  def index
    @current_user = current_user
    @courses = Course.where(creator: current_user)
  end
end
