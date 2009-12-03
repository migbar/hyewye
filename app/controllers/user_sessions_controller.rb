class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    session[:return_to] = params[:return_to] unless params[:return_to].blank?
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash[:notice] = "Welcome #{@user_session.record}!"
        redirect_back_or_default root_path
      else
        if params[:denied]
          flash[:notice] = "You did not allow HyeWye to use your Twitter account"
          redirect_to new_user_session_path
        else
          render :new
        end
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "You have logged out"
    redirect_back_or_default root_path
  end
end