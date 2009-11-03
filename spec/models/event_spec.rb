require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  should_belong_to :target, :polymorphic => true
  
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
  
  it "delegates user to target" do
    @user = Factory.build(:user)
    @event = Factory.build(:event, :target => Factory.build(:answer, :user => @user))
    @event.user.should == @user
  end
end