require File.dirname(__FILE__) + '/../spec_helper'

describe QuestionsController do
  describe "access control" do
    [:new, :create].each do |action|
      it "requires user to be logged in for action #{action}" do
        get action
        response.should redirect_to(new_user_session_path)
      end
    end
  end
  
  before(:each) do
    @question = mock_model(Question)
  end
  
  describe "handling GET new action" do
    before(:each) do
      login_user
    end
    
    def do_get
      get :new
    end
    
    it "builds a new question and assigns it for the view" do
      Question.should_receive(:new).and_return(@question)
      do_get
    end
    
    it "renders the new template" do
      do_get
      response.should render_template(:new)
    end
  end
  
  describe "handling POST create action" do
    before(:each) do
      current_user.questions.stub(:build).and_return(@question)
      login_user
    end
    
    def post_with_valid_attributes(options={})
      @question.should_receive(:save_with_notification).and_return(true)
      post :create, :question => options
    end
    
    def post_with_invalid_attributes
      @question.should_receive(:save_with_notification).and_return(false)
      post :create
    end
    
    it "builds a new question from params and assigns it to the view" do
      current_user.questions.should_receive(:build).with("body" => "blah blah").and_return(@question)
      post_with_valid_attributes(:body => "blah blah")
      assigns[:question].should == @question
    end
    
    it "sets the flash message and redirects to the home page on success" do
      post_with_valid_attributes
      flash[:notice].should == "thanks for asking!"
      response.should redirect_to(root_path)
    end
    
    it "renders the new template on failure" do
      post_with_invalid_attributes
      response.should render_template(:new)
    end
    
  end
end
