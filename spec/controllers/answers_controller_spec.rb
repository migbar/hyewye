require File.dirname(__FILE__) + '/../spec_helper'

describe AnswersController do
  before(:each) do
    @question = mock_model(Question)
    @answer = mock_model(Answer)
    @answers = [ mock_model(Answer) ]
    Question.stub(:find).and_return(@question)
    @question.stub_chain(:answers, :latest, :paginate).and_return(@answers)
  end
  
  describe "access control" do
    [:create].each do |action|
      it "requires user to be logged in for action #{action}" do
        get action, :question_id => 1 # url_for(:controller => 'answers', :action => 'index', :question_id => 1) => /questions/1/answers
        response.should redirect_to(new_user_session_path) # 301
      end
    end
    [:index].each do |action|
      it "does not require user to be logged in for action #{action}" do
        get action, :question_id => 1 # url_for(:controller => 'answers', :action => 'index', :question_id => 1) => /questions/1/answers
        response.should be_success # 200
      end
    end
  end
  
  describe "handling GET index action" do
    
    before(:each) do
      Answer.stub(:new).and_return(@answer)
      login_user
    end
    
    def do_get(options={})
      get :index, {:question_id => 1}.merge(options)
    end
    
    it "finds the specified question and assigns it for the view" do
      Question.should_receive(:find).with("7").and_return(@question)
      do_get(:question_id => "7")
      assigns[:question].should == @question
    end
    
    it "should paginate the latest answers for a question and assigns them for the view" do
      @question.answers.latest.should_receive(:paginate).with(hash_including(:page => "42")).and_return(@answers)
      do_get(:page => 42)
      assigns[:answers].should == @answers
    end
    
    it "builds a new answer and assigns it for the view" do
      Answer.should_receive(:new).and_return(@answer)
      do_get
      assigns[:answer].should == @answer
    end
    
    it "renders the index template" do
      do_get
      response.should render_template(:index)
    end
  end
  
  describe "handling POST create action" do
    
    before(:each) do
      Question.stub(:find).and_return(@question)
      # @question.stub_chain(:answers, :build).and_return(@answer)
      @question.answers.stub(:build).and_return(@answer)
      # Same as:
      # answers = mock("question answers", :build => @answer)
      # @question.stub(:answers).and_return(answers)
      @answer.stub(:user=)
      login_user
    end
    
    def post_with_valid_attributes(options={})
      @answer.should_receive(:save_with_notification).and_return(true)
      post :create, {:question_id => 1}.merge(options)
    end
    
    def post_with_invalid_attributes(options={})
      @answer.should_receive(:save_with_notification).and_return(false)
      post :create, {:question_id => 1}.merge(options)
    end
    
    it "finds the specified question and assigns it for the view" do
      Question.should_receive(:find).with("1").and_return(@question)
      post_with_valid_attributes
      assigns[:question].should == @question
    end
    
    it "builds a new answer for the question from params and assigns it for the view" do
      #implement ...consider the user that owns it ...
      @question.answers.should_receive(:build).with("body" => "foo").and_return(@answer)
      @answer.should_receive(:user=).with(current_user)
      post_with_valid_attributes(:answer => { :body => 'foo' })
      assigns[:answer].should == @answer
    end
    
    it "should paginate the latest answers for a question and assign them for the view on failure" do
      @question.answers.latest.should_receive(:paginate).with(hash_including(:page => "42")).and_return(@answers)
      post_with_invalid_attributes(:page => 42)
      assigns[:answers].should == @answers
    end
        
    it "sets the flash and redirects to the answers list for the question" do
      post_with_valid_attributes
      flash[:notice].should == "Thanks for answering!"
      response.should redirect_to(question_answers_path(@question)) # @question.to_param (from mock_model)
    end
    
    it "renders the index template on failure" do
      post_with_invalid_attributes
      response.should render_template(:index)
    end
    
end
  
end
