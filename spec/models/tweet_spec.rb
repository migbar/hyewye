require File.dirname(__FILE__) + '/../spec_helper'

describe Tweet do
  include ActionController::UrlWriter
  
  describe "#to_s" do
    before(:each) do
      @question = mock_model(Question, :body => "Short Question")
    end
    
    describe "for a question" do
      it "returns a tweet with the full body if not over 140 characters" do
        tweet = Tweet.new(@question)
        tweet.to_s.should == "#hyewye #{@question.body} #{question_answers_url(@question, :host => Settings.host)}"
      end
      
      it "returns a tweet with a trimmed body if over 140 characters" do
        @question.stub(:body).and_return("Foo bar" * 50)
        tweet = Tweet.new(@question).to_s
        tweet.size.should == 140
        escaped_url = Regexp.escape(question_answers_url(@question, :host => Settings.host))
        tweet.should =~ /^#hyewye Foo bar.+?\.{3} #{escaped_url}$/
      end
    end
    
    describe "for an answer" do
      before(:each) do
        @answer = mock_model(Answer, :question => @question, :body => "Short Answer", :choice_name => "i have") 
        @user = mock_model(User, :screen_name => "question_guy")
        @question.stub!(:user).and_return(@user)
      end
      it "returns a tweet with the full body if not over 140 characters" do
        tweet = Tweet.new(@answer)
        tweet.to_s.should == "@#{@user.screen_name} #{@answer.choice_name}, #{@answer.body} #hyewye #{question_answers_url(@question, :host => Settings.host)}"
      end
      
      it "return a tweet with a trimmed body if over 140 characters" do
        @answer.stub(:body).and_return("Foo bar" * 50)
        tweet = Tweet.new(@answer).to_s
        tweet.size.should == 140
        escaped_url = Regexp.escape(question_answers_url(@question, :host => Settings.host))
        tweet.should =~ /^@#{@user.screen_name} #{@answer.choice_name}, Foo bar.+?\.{3} #hyewye #{escaped_url}$/
      end
    end
  end
  
end
