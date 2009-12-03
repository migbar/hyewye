require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  before(:each) do
    @user = stub_model(User, :create_or_update => true)
  end
  
  describe "access control" do
    [:edit, :update].each do |action|
      it "requires login for the #{action} action" do
        get action
        response.should redirect_to(new_user_session_path)
      end
    end
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
      User.stub(:new).and_return(@user)
    end
    
    def post_with_valid_attributes(options={})
      controller.should_receive(:current_user).and_return(nil) # first time -> the filter that sends :current_user, expects nil
      controller.should_receive(:current_user).and_return(options[:user].try(:[], :login)) # second time -> our flash message code, we expect a true user
      @user.should_receive(:valid?).and_return(true)
      post :create, options
    end
    
    def post_with_invalid_attributes(options={})
      @user.should_receive(:valid?).and_return(false)
      post :create, options
    end

    it "builds a new User from params and assigns it for the view" do
      User.should_receive(:new).with(hash_including("password" => "secret")).and_return(@user)
      @user.should_receive(:login=).with("bob")
      @user.should_receive(:email=).with("test@example.com")
      post_with_valid_attributes(:user => { :login => "bob", :email => "test@example.com", :password => "secret" })
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
    
    it "sets the notice flash and redirects to the registration page if denied OAuth authentication" do
      post_with_invalid_attributes(:denied => "foo")
      flash[:notice].should == "You did not allow HyeWye to use your Twitter account"
      response.should redirect_to(new_account_path)
    end
  end
  
  describe "handling GET show" do
    
    describe "/users/:id" do
      before(:each) do
        User.stub(:find).and_return(@user)
        @events = (1..3).map { mock_model(Event) }
        @user.stub_chain(:events, :latest).and_return(@events)
      end

      def do_get(options={})
        get :show, {:id => 1}.merge(options)
      end

      it "finds the specified user and assigns it for the view" do
        User.should_receive(:find).with("42").and_return(@user)
        do_get(:id => 42)
        assigns[:user].should == @user
      end

      it "renders the show template" do
        do_get
        response.should render_template(:show)
      end

      it "finds the events for the user and assigns them for the view" do
        @user.events.should_receive(:latest).and_return(@events)
        do_get
        assigns[:events].should == @events
      end
    end
    
    describe "/account" do
      it "redirects to the account edit page" do
        get :show
        response.should redirect_to(edit_account_path)
      end
    end
    
  end
  
  describe "handling GET edit" do
    before(:each) do
      login_user
    end
    
    def do_get
      get :edit
    end
    
    it "assigns the current user for the view" do
      do_get
      assigns[:user].should == current_user
    end
    
    it "renders the edit template" do
      do_get
      response.should render_template(:edit)
    end
  end
  
  describe "handling PUT update" do
    before(:each) do
      login_user({}, :create_or_update => true)
      @user = current_user
    end
    
    def put_with_valid_attributes(options={})
      current_user.should_receive(:valid?).and_return(true)
      put :update, :user => options
    end
    
    def put_with_invalid_attributes(options={})
      current_user.should_receive(:valid?).and_return(false)
      put :update
    end
    
    it "assigns the current user for the view" do
      put_with_valid_attributes
      assigns[:user].should == current_user
    end
        
    it "assigns the updated attributes to the user model" do
      @user.should_receive(:attributes=).with(hash_including("password" => "secret"))
      put_with_valid_attributes("password" => "secret")
    end
    
    it "assigns the flash and redirects to the edit page on success" do
      put_with_valid_attributes
      flash[:notice].should == "Account successfully updated"
      response.should redirect_to(edit_account_path)
    end
    
    it "renders the edit template on failure" do
      put_with_invalid_attributes
      response.should render_template(:edit)
    end
  end
end