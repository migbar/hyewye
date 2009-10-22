class UserSessionsController < ApplicationController
  # before_filter :require_no_user, :only => [:new, :create]
  # before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Welcome #{current_user.login}!"
      redirect_to root_path
    else
      render :new
    end
  end
end