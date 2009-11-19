require File.dirname(__FILE__) + '/../spec_helper'

describe PasswordResetsController do
  before(:each) do
     @user = mock_model(User)
     @user.stub(:email).and_return("name@example.com")
  end

  describe "handling GET new" do
    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
  end  
  
  describe "handling POST create" do
    before(:each) do   
      @user.stub(:deliver_password_reset_instructions!)
    end
    
    def post_with_valid_email(options={})
      User.should_receive(:find_by_email).with("miguel@example.com").and_return(@user)
      post :create, {:email => "miguel@example.com"}.merge(options)
    end
    
    it "delivers password reset instructions to the user if user is found" do
      @user.should_receive(:deliver_password_reset_instructions!)
      post_with_valid_email
    end
    
    it "sets the flash message and redirects to the home page" do
      @user.should_receive(:email).and_return("blah")
      post_with_valid_email
      flash[:notice].should == "We have sent password reset instructions to blah. Please check your email."
      response.should redirect_to(root_path)
    end
  end
  
  describe "handling GET edit" do
    def get_with_valid_token
      User.should_receive(:find_using_perishable_token).with("foo").and_return(@user)
      get :edit, :id => "foo"
    end
    
    def get_with_invalid_token
      User.should_receive(:find_using_perishable_token).with("foo").and_return(nil)
      get :edit, :id => "foo"
    end
    
    it "finds the user by the perishable token and assigns it for the view" do
      get_with_valid_token
      assigns[:user].should == @user
    end
    
    it "renders the edit template with valid token" do
      get_with_valid_token
      response.should render_template(:edit)
    end
    
    it "sets the flash message and redirects to the home page if the token is not valid" do
      get_with_invalid_token
      flash[:notice].should == "We're sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "reset password process."
      response.should redirect_to(root_path)
    end
  end
  
  describe "handling PUT update" do
    before(:each) do
      @user.stub(:password=)
      @user.stub(:password_confirmation=)
      @user.stub(:save)
    end
    
    def put_with_valid_token(options={})
      User.should_receive(:find_using_perishable_token).with("foo").and_return(@user)      
      put :update, :id => "foo", :user => options
    end

    def put_with_invalid_token
      User.should_receive(:find_using_perishable_token).with("foo").and_return(nil)      
      put :update, :id => "foo"
    end
        
    it "finds the user by the perishable token and assigns it for the view" do
      put_with_valid_token
      assigns[:user].should == @user
    end
    
    it "sets the flash message and redirects to the home page if the token is not valid" do
      put_with_invalid_token
      flash[:notice].should == "We're sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "reset password process."
      response.should redirect_to(root_path)
    end
    
    it "assigns the password and password confirmation to the user" do
      @user.should_receive(:password=).with("foo")
      @user.should_receive(:password_confirmation=).with("bar")
      put_with_valid_token(:password => "foo", :password_confirmation => "bar")
    end
    
    it "sets the flash message and redirects to the home page on success" do
      @user.should_receive(:save).and_return(true)
      put_with_valid_token
      flash[:notice].should == "Password successfully updated"
      response.should redirect_to(root_path)
    end
    
    it "renders the edit template on failure" do
      @user.should_receive(:save).and_return(false)
      put_with_valid_token
      response.should render_template(:edit)
    end
  end
end














