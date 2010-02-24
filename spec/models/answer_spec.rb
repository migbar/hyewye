# == Schema Information
#
# Table name: answers
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      indexed
#  question_id :integer(4)      indexed
#  choice      :integer(4)
#  body        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

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
    should_validate_length_of :body, :maximum => 255   
    should_validate_inclusion_of :choice, :in => 1..3, :message => "please select one"
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
    
    Answer.choices.keys.each do |choice|
      describe choice do
        it "fetches the answers having choice :#{choice}" do
          @expected_answers = (1..4).map do |value|
            Factory.create(:answer, :choice => Answer.choices[choice])
          end
          other_options = Answer.choices.values - [Answer.choices[choice]]
          Factory.create(:answer, :choice => other_options.first)
          Factory.create(:answer, :choice => other_options.last)
          Answer.send(choice).should == @expected_answers
        end
      end
    end
  end
end
