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
      post_with_valid_attributes
      flash[:notice].should == "Account Created!"
      response.should redirect_to(root_path)
    end
    
    it "renders the new template on failure" do
      post_with_invalid_attributes
      response.should render_template(:new)
    end
    
    # it "creates a User given valid attributes" do
    #   do_post
    #   User.should_receive(:new).with(@valid_arguments).and_return(@user)
    #   response.should redirect_to(root_path)
    #   flash[:notice].should == "Account Created!"
    # end
    
  end
  
end