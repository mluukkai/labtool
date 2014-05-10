class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @checklists = Checklist.order :title
  end

  def toggle_hidden
    @user = User.find(params[:id])
    @user.hidden = (not @user.hidden?)
    @user.save
    redirect_to @user, notice: 'User was successfully updated.'
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      redirect_to @user, notice: 'Something wrong....'
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user]) if current_user==@user
    redirect_to @user, notice: 'User was successfully updated.'
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'User was deleted.'
  end
end
