require File.dirname(__FILE__) + '/../spec_helper'

describe EventsHelper do
  describe "question_for_event" do
    before(:each) do
      @event = mock_model(Event)
      @question = mock_model(Question)
      @answer = mock_model(Answer)
      @event.stub_chain(:target, :question).and_return(@question)
    end
    
    it "returns the target if target is a Question" do
      @event.should_receive(:target_type).and_return("Question")
      @event.should_receive(:target).and_return(@question)
      helper.question_for_event(@event).should == @question
    end
    
    it "returns the target if target is a Question" do
      @event.should_receive(:target_type).and_return("Answer")
      @event.target.should_receive(:question).and_return(@question)
      helper.question_for_event(@event).should == @question
    end
  end
end
