require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController do
  before(:each) do
    @user_session = mock_model(UserSession)
  end

  describe "handling GET new" do
    it "builds a new user session and assigns it for the view" do
      UserSession.should_receive(:new).and_return(@user_session)
      get :new
      assigns[:user_session] == @user_session
    end
    
    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
  end
  
  describe "handling POST create" do
    before(:each) do
      UserSession.stub!(:new).and_return(@user_session)
      UserSession.stub!(:find).and_return(@user_session)
      @user_session.stub!(:record).and_return(mock_model(User, :login => 'my_login'))
    end
    
    def post_with_valid_attributes(options={})
      @user_session.should_receive(:save).and_return(true)
      post :create, options
    end
    
    def post_with_invalid_attributes
      @user_session.should_receive(:save).and_return(false)
      post :create
    end

    it "builds a new User Session from params and assigns it for the view" do
      UserSession.should_receive(:new).with("login" => "my_login").and_return(@user_session)
      post_with_valid_attributes(:user_session => { :login => "my_login" })
      assigns[:user_session].should == @user_session
    end
    
    it "redirects to the home page and sets the flash message on success" do
      post_with_valid_attributes
      flash[:notice].should == "Welcome my_login!"
      response.should redirect_to(root_path)
    end
    
    it "renders the new template on failure" do
      post_with_invalid_attributes
      response.should render_template(:new)
    end

  end
  
end