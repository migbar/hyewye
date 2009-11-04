require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController do
  before(:each) do
    @user_session = mock_model(UserSession)
  end

  describe "handling GET new" do
    before(:each) do
      UserSession.stub(:find).and_return(nil)
    end
    
    it "stores the location to return to" do
      get :new, {:return_to => "/foo/bar"}
      session[:return_to].should == "/foo/bar"
    end
    
    it "should not over write the session's return_to if the params' return_to is blank" do
      session[:return_to] = "/foo/bar"
      get :new, {:return_to => ""}
      session[:return_to].should == "/foo/bar"
    end
    
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
      UserSession.stub(:find).and_return(nil) # logged out
      UserSession.stub!(:new).and_return(@user_session)
      @user_session.stub!(:record).and_return(mock_model(User, :login => 'my_login'))
    end
    
    def post_with_valid_attributes(options={})
      @current_user = mock_model(User, :login => options[:user_session].try(:[], :login)) # option[:user_session] && options[:user_session][:login]
      controller.should_receive(:current_user).and_return(nil) # first time it is the filter that sends :current_user, expects nil
      controller.should_receive(:current_user).and_return(@current_user) # second time, it is our code, we expect a true user
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
      post_with_valid_attributes(:user_session => { :login => "my_login" })
      flash[:notice].should == "Welcome my_login!"
      response.should redirect_to(root_path)
    end
    
    it "renders the new template on failure" do
      post_with_invalid_attributes
      response.should render_template(:new)
    end

  end
  
  describe "handling DELETE destroy" do
    def do_delete
      delete :destroy
    end
    
    it "redirects to the login page if not logged in" do
      do_delete
      response.should redirect_to(new_user_session_path)
    end
    
    describe "when logged in" do
      before(:each) do
        login_user
        user_session.stub(:destroy)
      end
      
      it "destroys the current user session" do
        user_session.should_receive(:destroy)
        do_delete
      end
      
      it "sets the flash message and redirects to the home page" do
        do_delete
        flash[:notice].should == "You have logged out"
        response.should redirect_to(root_path)
      end
    end
    
    
  end
  
end








