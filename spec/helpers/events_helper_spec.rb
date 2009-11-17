require File.dirname(__FILE__) + '/../spec_helper'

describe EventsHelper do
  describe "question_for_event" do
    before(:each) do
      @event = mock_model(Event)
      @question = mock_model(Question)
      @answer = mock_model(Answer)
      @event.stub_chain(:subject, :question).and_return(@question)
    end
    
    it "returns the subject if subject is a Question" do
      @event.should_receive(:subject_type).and_return("Question")
      @event.should_receive(:subject).and_return(@question)
      helper.question_for_event(@event).should == @question
    end
    
    it "returns the subject if subject is a Question" do
      @event.should_receive(:subject_type).and_return("Answer")
      @event.subject.should_receive(:question).and_return(@question)
      helper.question_for_event(@event).should == @question
    end
  end
  
  describe "present_events" do
    it "wraps each event in a presenter" do
      @events = (1..4).map do 
        mock_model(Event)
      end
      @presenters = helper.present_events(@events)
      @presenters.each_with_index do |presenter, index|
        presenter.should be_an_instance_of(EventPresenter)
        presenter.event.should == @events[index]
      end
    end
  end
end
