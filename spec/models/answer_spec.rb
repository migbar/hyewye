require 'spec_helper'

describe Answer do
  describe "structure" do
    should_have_column :choice, :type => :integer
    should_have_column :body, :type => :string    
  end
  
  describe "associations" do
    should_belong_to :user
    should_belong_to :question    
  end
  
  describe "validations" do
    should_validate_presence_of :body
    should_validate_length_of :body, :maximum => 140   
    should_validate_inclusion_of :choice, :in => 1..3 
  end
  
  describe "named_scope" do
    describe "latest" do
      it "fetches the answers ordered by created_at" do
        @expected_answers = (1..4).map do |value|
          Factory.create(:answer, :created_at => value.hours.ago)
        end
        @answers = Answer.latest
        @answers.should == @expected_answers
      end
    end
  end
  
  describe "creating associated event" do 
    before(:each) do
      Event.delete_all
    end
    
    it "creates an asosciated event when it is created successfully" do
      lambda {
        @answer = Factory.create(:answer, :question => nil)
      }.should change(Event, :count).by(1)
      
      Event.first.target.should == @answer
    end
  end
end
