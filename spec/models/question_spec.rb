require File.dirname(__FILE__) + '/../spec_helper'

describe Question do
  should_have_column :body, :type => :string
  should_belong_to :user
  should_validate_length_of :body, :maximum => 140
  should_validate_presence_of :body
  should_have_many :answers
  should_have_one :event, :as => :target
  
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
end