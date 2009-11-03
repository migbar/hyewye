class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    session[:return_to] = params[:return_to]
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Welcome #{current_user.login}!"
      redirect_back_or_default root_path
    else
      render :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "You have logged out"
    redirect_back_or_default root_path
  end
end