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
        tweet.to_s.should == "#hyewye #{@question.body} #{question_answers_url(@question, :host => Tweet::HOST)}"
      end
      
      it "returns a tweet with a trimmed body if over 140 characters" do
        @question.stub(:body).and_return("Foo bar" * 50)
        tweet = Tweet.new(@question).to_s
        tweet.size.should == 140
        escaped_url = Regexp.escape(question_answers_url(@question, :host => Tweet::HOST))
        tweet.should =~ /^#hyewye Foo bar.+?\.{3} #{escaped_url}$/
      end
    end
    
    describe "for an answer" do
      before(:each) do
        @answer = mock_model(Answer, :question => @question, :body => "Short Answer") 
      end
      it "returns a tweet with the full body if not over 140 characters" do
        tweet = Tweet.new(@answer)
        tweet.to_s.should == "@question_guy I HAVE, and it was great! #hyewye http://bit.ly"
      end
      
      it "return a tweet with a trimmed body if over 140 characters" do
        pending
      end
    end
  end
  
  describe "#url" do
    it "returns the URL for the answers page of the specified question" do
      question = mock_model(Question)
      tweet = Tweet.new(question)
      tweet.url.should == question_answers_url(question, :host => Tweet::HOST)
    end
    
    it "returns the URL for the answers page of the specified answer's question" do
      question = mock_model(Question)
      answer = mock_model(Answer, :question => question)
      tweet = Tweet.new(answer)
      tweet.url.should == question_answers_url(question, :host => Tweet::HOST)
    end
  end
end
