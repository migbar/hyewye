require File.dirname(__FILE__) + '/../spec_helper'

describe Question do
  
  describe "structure" do
    should_have_column :body, :type => :string    
  end
  
  describe "associations" do
    should_belong_to :user
    should_have_many :answers
    should_have_one :event, :as => :target    
  end
  
  describe "validations" do
    should_validate_length_of :body, :maximum => 140
    should_validate_presence_of :body    
  end
    
  describe "creating associated event" do      
    before(:each) do
      Event.delete_all
    end
    
    it "creates an asosciated event when it is created successfully" do
      lambda {
        @question = Factory.create(:question)
      }.should change(Event, :count).by(1)
      
      Event.first.target.should == @question
      @question.event.user.should == @question.user
    end
  end
  
  describe "answers" do
    def build_question_with_answers
      @question = Factory.create(:question)
      2.times { Factory.create(:answer, :question => @question, :choice => Answer.choices[:i_have]) }
      3.times { Factory.create(:answer, :question => @question, :choice => Answer.choices[:i_would]) }
      5.times { Factory.create(:answer, :question => @question, :choice => Answer.choices[:i_would_never]) }
      @question.reload
    end
    
    describe "#i_have_percent" do
      it "returns the percent of answers having choice i_have" do
        build_question_with_answers
        @question.answers.i_have_percent.should == 20
      end
      
      it "it returns 0 if no answers defined" do
        @question = Factory.create(:question)
        @question.answers.i_have_percent.should == 0
      end
    end
    
    describe "#i_would_percent" do
      it "returns the percent of answers having choice i_would" do
        build_question_with_answers
        @question.answers.i_would_percent.should == 30
      end
      
      it "it returns 0 if no answers defined" do
        @question = Factory.create(:question)
        @question.answers.i_would_percent.should == 0
      end
    end
    
    describe "#i_would_never_percent" do
      it "returns the percent of answers having choice i_would_never" do
        build_question_with_answers
        @question.answers.i_would_never_percent.should == 50
      end
      
      it "it returns 0 if no answers defined" do
        @question = Factory.create(:question)
        @question.answers.i_would_never_percent.should == 0
      end
    end
    
    
  end
  
  describe "delegations" do
    before(:each) do
      @question = Question.new
    end
    
    [:i_have_percent, :i_would_percent, :i_would_never_percent].each do |message|
      it "delegates #{message} to answers" do
        @question.answers.should_receive(message)
        @question.send(message)
      end
    end
  end
  
  it "#to_s returns the body of the question" do
    question = Question.new(:body => "foo")
    question.to_s.should == "foo"
  end
end