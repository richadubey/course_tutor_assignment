class CoursesController < ApplicationController

  def index
    courses = Course.includes(:tutors).all
    render json: courses.as_json(include: :tutors), status: :ok
  end
  
end
