require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  before(:each) do
    @user = mock_model(User)
  end
  
  describe "handing GET new" do
    def do_get
      get :new
    end
    
    it "creates a new User and assigns it for the view" do
      User.should_receive(:new).and_return(@user)
      do_get
      assigns[:user].should == @user
    end
    
    it "renders the new template" do
      do_get
      response.should render_template(:new)
    end
  end
  
  describe "handling POST create" do
    before(:each) do
      User.stub!(:new).and_return(@user)
    end
    
    def post_with_valid_attributes(options={})
      @current_user = mock_model(User, :login => options[:user].try(:[], :login)) # same as-> options[:user] && options[:user][:login]
      controller.should_receive(:current_user).and_return(nil) # first time -> the filter that sends :current_user, expects nil
      controller.should_receive(:current_user).and_return(@current_user) # second time -> our flash message code, we expect a true user
      @user.should_receive(:save).and_return(true)
      post :create, options
    end
    
    def post_with_invalid_attributes
      @user.should_receive(:save).and_return(false)
      post :create
    end

    it "builds a new User from params and assigns it for the view" do
      User.should_receive(:new).with("email" => "test@example.com").and_return(@user)
      post_with_valid_attributes(:user => { :email => "test@example.com" })
      assigns[:user].should == @user
    end
    
    it "redirects to the home page and sets the flash message on success" do
      post_with_valid_attributes(:user => { :login => "my_login" })
      flash[:notice].should == "Thank you for registering my_login, your account has been created!"
      response.should redirect_to(root_path)
    end
    
    it "renders the new template on failure" do
      post_with_invalid_attributes
      response.should render_template(:new)
    end

  end
  
end