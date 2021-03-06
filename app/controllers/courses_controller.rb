class CoursesController < ApplicationController
  before_action :find_course, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @courses = Course.all.order("created_at DESC")
  end

  def show
    @comments = Comment.where(course_id: @course)
    @random_course = Course.where.not(id: @course).order("RANDOM()").first
  end

  def new
    @course = current_user.courses.build
  end

  def create
    @course = current_user.courses.build(course_params)

    if @course.save
      flash[:notice] = "Successfully created course"
      redirect_to @course
    else
      flash[:alert] = "Error creating new course"
      render 'new'
    end
  end

  def edit

  end

  def update
    if @course.update(course_params)
      flash[:notice] = "Successfully updated course"
      redirect_to @course
    else
      flash[:alert] = "Error updating course"
      render 'edit'
    end
  end

  def destroy
    if @course.destroy
      flash[:notice] = "Successfully deleted course"
      redirect_to root_path
    else
      flash[:alert] = "Error updating course"
    end
  end

  private

  def find_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :body, :image)
  end

end
