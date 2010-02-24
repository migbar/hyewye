require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do
  describe "handling GET index" do
    before(:each) do
      @events = (1..3).map { mock_model(Event) }
      Event.stub(:latest).and_return(@events)
      @question = mock_model(Question)
      Question.stub(:for_sidebar).and_return(@question)
    end
    
    def do_get
      get :index
    end
    
    it "renders the index template" do
      do_get
      response.should render_template(:index)
    end
    
    it "fetches the latest events and assigns them to the view" do
      Event.should_receive(:latest).with(Settings.home_events_limit).and_return(@events)
      do_get
      assigns[:events].should == @events
    end
    
    it "fetches a relevant question for the sidebar and assigns it for the view" do
      Question.should_receive(:for_sidebar).and_return(@question)
      do_get
      assigns[:sidebar_question].should == @question
    end
    
  end
end