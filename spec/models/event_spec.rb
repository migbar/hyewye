require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  should_belong_to :subject, :polymorphic => true
  should_belong_to :user
  
  describe "named_scope" do
    describe "latest" do
      should_have_named_scope :latest
      
      before(:each) do
        @expected_results = (1..5).map { |i| Factory.create(:event, :created_at => i.minutes.ago) }
        (1..3).map { |i| Factory.create(:event, :created_at => (i+1).hours.ago) }
      end
      
      it "fetches the latest events, most recent first, since a time stamp" do
        results = Event.latest
        results.should == @expected_results
      end
    end
  end
  
  it "does not double wrap" do
    @question = Question.create(:body => 'foo') # Factory.create(:answer)
    @question.event.subject.should == @question
    
    @answer = Answer.create(:question => @question, :body => 'bar', :choice => 1)
    @answer.event.subject.should == @answer
    
    event = Factory.create(:event, :subject => @answer)
    event.subject.should_not == event
    event.subject.should == @answer
  end
end