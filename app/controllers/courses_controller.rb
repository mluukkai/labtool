class CoursesController < ApplicationController
  caches_action :show

  def index
    @courses = Course.all
  end

  def activity
    Course.all.each do |c|
      c.update_attributes :active => c.id == params[:id].to_i
    end
    redirect_to courses_path
  end

  def show
    @course = Course.find(params[:id])
    @students = @course.registered_users
  end

  def new
    @course = Course.new
  end

  def edit
    expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    @course = Course.find(params[:id])
  end

  def create
    expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    @course = Course.new(params[:course])
    @course.review_round = 0
    @course.week = 0
    @course.active = false

    if @course.save
      redirect_to @course, :notice => 'Course was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    do_update :course, params
  end

  def destroy
    expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    @course = Course.find(params[:id])
    @course.destroy
    redirect_to courses_path, :notice => 'Course was destroyed'
  end

end
