require File.dirname(__FILE__) + '/../spec_helper'

describe EventsHelper do
  describe "#question_for_event" do
    before(:each) do
      @event = mock_model(Event)
      @question = mock_model(Question)
      @answer = mock_model(Answer)
      @event.stub_chain(:subject, :question).and_return(@question)
    end
    
    it "returns the question if subject is a Question" do
      @event.should_receive(:subject_type).and_return("Question")
      @event.should_receive(:subject).and_return(@question)
      helper.question_for_event(@event).should == @question
    end
    
    it "returns the question if subject is an Answer" do
      @event.should_receive(:subject_type).and_return("Answer")
      @event.subject.should_receive(:question).and_return(@question)
      helper.question_for_event(@event).should == @question
    end
  end
  
  describe "#present_events" do
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
  
  describe "#linkify" do
    before(:each) do
      @linkifiable = mock("linkifiable object",
        :to_s => "linkifiable http://foobar.com/foo/bar/baz/one/two/three/four/five body")
    end
    
    it "escapes the text before auto linking it" do
      @linkifiable.should_receive(:to_s).and_return("linkifiable http://foobar.com body")
      helper.should_receive(:h).with("linkifiable http://foobar.com body").and_return("escaped html")
      helper.should_receive(:auto_link).with("escaped html", an_instance_of(Hash))
      helper.linkify(@linkifiable)
    end
    
    it "converts a text fragment into a link" do
      result = helper.linkify("http://foobar.com")
      result.should have_tag("a[rel=nofollow][target=_blank][href=?]", "http://foobar.com")
    end
    
    it "truncates the anchor label to 40 charcters and strip out the protocol" do
      result = helper.linkify(@linkifiable)
      result.should have_tag("a", "foobar.com/foo/bar/baz/one/two/three/...")
    end
  end
end
