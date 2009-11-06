require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  should_belong_to :target, :polymorphic => true
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
  
end