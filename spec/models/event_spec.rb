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
  
  it "wraps a question as a subject" do
    @question = Factory.create(:question)
    @question.event.subject.should == @question
  end
  
  it "wraps an answer s a subject" do
    @answer = Factory.create(:answer)
    @answer.event.subject.should == @answer
  end
  
  it "sends the user #event_created with the subject on create" do
    user = Factory.build(:user)
    question = Factory.build(:question)
    event = Factory.build(:event, :subject => question, :user => user, :notify_user => true)
    user.should_receive(:event_created).with(question)
    event.save!
  end
end