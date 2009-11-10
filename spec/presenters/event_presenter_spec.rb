require 'spec_helper'

describe EventPresenter do
  include ActionView::Helpers::RecordIdentificationHelper
  
  ANCHOR_REGEX = /<a href="([^"]+)">([^<]+)<\/a>/
  
  before(:each) do
    @yielded = false
  end
  
  def do_yield
    @yielded = true
  end
  
  describe "delegates" do
    it "target to event" do
      @presenter = EventPresenter.new(:event => Factory.build(:answer_event))
      @presenter.target.should == @presenter.event.target
    end
    
    it "user to event" do
      @presenter = EventPresenter.new(:event => Factory.build(:answer_event, :user => Factory.build(:user)))
      @presenter.user.should == @presenter.event.user
    end
    
    it "body to event" do
      @presenter = EventPresenter.new(:event => Factory.build(:answer_event))
      @presenter.body.should == @presenter.event.target.body
    end

    it "login to user" do
      @presenter = EventPresenter.new(:event => Factory.build(:answer_event, :user => Factory.build(:user)))
      @presenter.login.should == @presenter.event.user.login
    end  
  end
  
  describe "#when_answer" do
    it "yields if event target is an answer" do
      @presenter = EventPresenter.new(:event => Factory.build(:answer_event))
      @presenter.when_answer do
        do_yield
      end
      @yielded.should be_true
    end
    
    it "does not yield if event target is a question" do
      @presenter = EventPresenter.new(:event => Factory.build(:question_event))
      @presenter.when_answer do
        do_yield
      end
      @yielded.should be_false
    end  
  end
  
  describe "#choice" do
    it "returns the choice of the answer if the event is an answer event" do
      # @choice = 3
      # @presenter = EventPresenter.new(:event => Factory.build(:event, :target => Factory.build(:answer, :choice => @choice)))
      # @presenter.choice.should == @choice
      # -- OR --
      @event = Factory.build(:answer_event)
      @choice = @event.target.choice 
      @presenter = EventPresenter.new(:event => @event)
      @presenter.choice.should == @choice
    end
    
    #(above) check choice results
    #--OR--
    #(below) just make sure it delegates 
    
    it "delegates #choice to the event's target if it's an answer event" do
      @presenter = EventPresenter.new(:event => Factory.build(:answer_event))
      @presenter.target.should_receive(:choice)
      @presenter.choice
    end
    
    it "raises error if the event is a question" do
      @presenter = EventPresenter.new(:event => Factory.build(:question_event))
      lambda {
        @presenter.choice
      }.should raise_error(NoMethodError)
    end
  end
  
  describe "#dom_id" do
    it "returns the right dom id for the answer" do
      @presenter = EventPresenter.new(:event => Factory.build(:answer_event))
      @presenter.dom_id.should == "answer_#{@presenter.event.target.id}"
    end
    
    it "returns the right dom id for the question" do
      @presenter = EventPresenter.new(:event => Factory.build(:question_event))
      @presenter.dom_id.should == "question_#{@presenter.event.target.id}"
    end
  end
  
  describe "#dom_class" do
    it "returns the right css class for the answer" do
      @presenter = EventPresenter.new(:event => Factory.build(:answer_event))
      @presenter.dom_class.should == "answer"
    end
    it "returns the right css class for the question" do
      @presenter = EventPresenter.new(:event => Factory.build(:question_event))
      @presenter.dom_class.should == "question"
    end
  end
  
  describe "#link_to_user" do
    before(:each) do
      @user = Factory.build(:user)
      @presenter = EventPresenter.new(:event => Factory.build(:answer_event, :user => @user))
      @presenter.controller = mock("controller")
    end
    
    it "returns the link to the show" do
      @presenter.controller.should_receive(:user_path).twice.with(@user).and_return("/users/1")
      @presenter.link_to_user[ANCHOR_REGEX, 1].should == "/users/1"
      @presenter.link_to_user[ANCHOR_REGEX, 2].should == @user.login
    end
  end
  
  describe "#link_to_question" do
    before(:each) do
      @event = Factory.create(:question_event)
      @question = @event.target
      @presenter = EventPresenter.new(:event => @event, :controller => mock("controller"))
    end
    
    it "returns the link to the question" do
      @presenter.controller.should_receive(:question_answers_path).with(@question).twice.and_return("/questions/1/answers")
      @presenter.link_to_question("answer")[ANCHOR_REGEX, 1].should == "/questions/1/answers"
      @presenter.link_to_question("answer")[ANCHOR_REGEX, 2].should == "answer"
    end
  end
  
  describe "#question" do
    before(:each) do
      @event = mock_model(Event)
      @question = mock_model(Question)
      @answer = mock_model(Answer)
      @event.stub_chain(:target, :question).and_return(@question)
      
      @presenter = EventPresenter.new(:event => @event)
    end
    
    it "returns the target if target is a Question" do
      @event.should_receive(:target_type).and_return("Question")
      @event.should_receive(:target).and_return(@question)
      @presenter.question.should == @question
    end
    
    it "returns the target's question if target is a Answer" do
      @event.should_receive(:target_type).and_return("Answer")
      @event.target.should_receive(:question).and_return(@question)
      @presenter.question.should == @question
    end
  end
  
  describe "#method_missing" do
    before(:each) do
      @controller = mock("controller")
      @presenter = EventPresenter.new(:event => Factory.build(:event), :controller => @controller)
    end
    
    it "delegates all named routes to the controller" do
      @controller.should_receive(:some_path).with("url arguments")
      @presenter.some_path("url arguments")
      @controller.should_receive(:some_url).with("url arguments")
      @presenter.some_url("url arguments")
    end
    
    it "handles all non-routing methods normally" do
      lambda {
        @presenter.unknown_method
      }.should raise_error(NoMethodError)
    end
  end
end















