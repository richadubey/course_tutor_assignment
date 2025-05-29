class CoursesController < ApplicationController

  def index
    courses = Course.includes(:tutors).all
    render json: courses.as_json(include: :tutors), status: :ok
  end

  def create
    course = Course.new(course_params)
    if course.save
      render json: course.as_json(include: :tutors), status: :created
    else
      render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
    end
    rescue ActiveRecord::RecordNotUnique => e
      render json: { errors: ["Tutor email must be unique"] }, status: :unprocessable_entity
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, tutors_attributes: [:name, :email])
  end

end
