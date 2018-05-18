class RegistrationsController < ApplicationController
  skip_before_filter :authenticate, :only => [:new, :create, :redirect]

  def toggle_activity
    expire_fragment('current_course')
    #expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    @registration = Registration.find(params[:registration])
    @registration.toggle_activity
    @registration.save
    redirect_to :back, :notice=> 'Registration status changed'
  end

  def index
    @registrations = Registration.current.select{|r| r.active}.sort{ |a, b| a.user.surename <=> b.user.surename }
    passive_registrations = Registration.current.select{|r| not r.active}.sort{ |a, b| a.user.surename <=> b.user.surename }

    @registrations += passive_registrations

    @past_registrations = Registration.past
  end

  def show
    @registration = Registration.find(params[:id])
  end

  def new
    expire_fragment('current_course')
    #expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    @registration = Registration.new
  end

  def edit
    expire_fragment('current_course')
    #expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    @registration = Registration.find(params[:id])
    render "admin_edit"
  end

  def create
    expire_fragment('current_course')
    #expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    course = Course.find_by_active(true)
    user = User.find_or_create(params[:user])

    if not user.current_registration.nil?
      return redirect_to "https://studies.cs.helsinki.fi/tktl-labtool/mypage/#{user.student_number}",
                         :notice => "You have already registered for the current course!"
    end

    @registration = Registration.new(params[:registration])
    if user.valid? and @registration.valid?
      @registration.participate_review1 = true
      @registration.participate_review2 = true
      @registration.active = true
      user.registrations << @registration
      course.registrations << @registration
      session[:student_number] = user.student_number
      redirect_to "https://studies.cs.helsinki.fi/tktl-labtool/mypage/#{user.student_number}", :notice =>'Registration done!'
    else
      @user = user
      render :action => "edit"
    end
  end

  def update
    expire_fragment('current_course')
    #expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    @registration = Registration.find(params[:id])
    @registration.update_attributes(params[:registration])
    redirect_to @registration.user, :notice => "Registration was successfully updated"
  end

  def destroy
    expire_fragment('current_course')
    #expire_action :controller => 'courses', :action => 'show', :id => Course.active.id
    @registration = Registration.find(params[:id])
    @registration.destroy
    redirect_to registrations_path, :notice => 'Registration destroyed'
  end
end
