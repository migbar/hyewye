class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:edit, :update] 
  
  # GET /users/:id
  # GET /account
  def show
    if request.path =~ /users/
      @user = User.find(params[:id])
      @events = @user.events.latest
    else
      redirect_to edit_account_path
    end
  end

  # GET /account/new
  def new
    @user = User.new
  end
  
  # POST /account
  def create
    @user = User.new(params[:user])
    
    if params[:user]
      @user.email = params[:user][:email]
      @user.login = params[:user][:login]
    end
    
    @user.save do |result|
      if result
        redirect_to root_path
        flash[:notice] = "Thank you for registering #{current_user}, your account has been created!"
      else
        render :new
      end
    end
    
  end
  
  # GET /account/edit
  def edit
    @user = current_user
  end
  
  # PUT /account
  def update
    @user = current_user
    @user.attributes = params[:user]
    
    @user.save do |result|
      if result
        flash[:notice] = "Account successfully updated"
        redirect_to edit_account_path
      else 
        render :edit
      end
    end
    
  end
end