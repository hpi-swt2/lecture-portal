class HomeController < ApplicationController
  def index
    if current_user
      if current_user.is_student
        redirect_to current_lectures_url
      else
        redirect_to lectures_url
      end
    end
  end
end
