class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_path
      flash[:notice] = "Thank you for registering #{current_user.login}, your account has been created!"
    else
      render :new
    end
  end
  
end