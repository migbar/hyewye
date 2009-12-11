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
        tweet.url = "http://bit.ly/blah"
        tweet.to_s.should == "#hyewye #{@question.body} #{tweet.url}"
      end
      
      it "returns a tweet with a trimmed body if over 140 characters" do
        @question.stub(:body).and_return("Foo bar" * 50)
        tweet = Tweet.new(@question)
        tweet.url = "http://bit.ly/blah"
        tweet_str = tweet.to_s
        tweet_str.size.should == 140
        escaped_url = Regexp.escape(tweet.url)
        tweet_str.should =~ /^#hyewye Foo bar.+?\.{3} #{escaped_url}$/
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
        tweet.url = "http://bit.ly/blah"
        tweet.to_s.should == "@#{@user.screen_name} #{@answer.choice_name}, #{@answer.body} #hyewye #{tweet.url}"
      end
      
      it "return a tweet with a trimmed body if over 140 characters" do
        @answer.stub(:body).and_return("Foo bar" * 50)
        tweet = Tweet.new(@answer)
        tweet.url = "http://bit.ly/blah"
        tweet_str = tweet.to_s
        tweet_str.size.should == 140
        escaped_url = Regexp.escape(tweet.url)
        tweet_str.should =~ /^@#{@user.screen_name} #{@answer.choice_name}, Foo bar.+?\.{3} #hyewye #{escaped_url}$/
      end
    end
  end
  
  describe "#url" do
    before(:each) do
      @question = mock_model(Question, :body => "have plastic surgery?", :to_param => "4")
      @tweet = Tweet.new(@question)
      @tweet.stub(:question_answers_url).and_return("http://hyewye.com/foo")
      @tweet.stub(:shorten).and_return("http://bit.ly/foo")
    end
    
    it "builds the url for the subject" do
      @tweet.should_receive(:question_answers_url).with("4", :host => Settings.host).and_return("http://hyewye.com/foo")
      @tweet.url
    end
    
    it "shortens the url for the subject and memoizes it" do
      @tweet.should_receive(:shorten).with("http://hyewye.com/foo").and_return("http://bit.ly/foo")
      @tweet.url.should == "http://bit.ly/foo"
      @tweet.should_not_receive(:shorten)
      @tweet.url.should == "http://bit.ly/foo"
    end
  end
  
  describe "#body" do
    before(:each) do
      @question = mock_model(Question, :body => "A" * 140, :to_param => "4")
      @tweet = Tweet.new(@question)
    end
    
    it "truncates the subject body to fit within 140 characters given the rest of the components" do
      @tweet.body(%w[foo bar baz]).size.should == 128
    end
  end
  
  describe "#bitly_authorization" do
    it "builds a bitly authorization with the login and key and returns it" do
      @question = mock_model(Question, :body => "A" * 140, :to_param => "4")
      @tweet = Tweet.new(@question)
      UrlShortener::Authorize.should_receive(:new).with(Settings.bitly.login, Settings.bitly.api_key).and_return("authorization")
      @tweet.bitly_authorization.should == "authorization"
    end
  end
  
  describe "#shorten" do
    before(:each) do
      @question = mock_model(Question, :body => "A" * 140, :to_param => "4")
      @tweet = Tweet.new(@question)
      @tweet.stub(:bitly_authorization).and_return(mock(UrlShortener::Authorize))
      
      @shorten = mock("shortening", :urls => "http://bit.ly/foo")
      
      @client = mock(UrlShortener::Client)
      @client.stub(:shorten).and_return(@shorten)
      
      UrlShortener::Client.stub(:new).and_return(@client)
    end
    
    it "builds a bitly client from an authorization" do
      UrlShortener::Client.should_receive(:new).with(@tweet.bitly_authorization).and_return(@client)
      @tweet.shorten("http://hyewye.com/")
    end
 
    it "uses the client to shorten the url" do
      @client.should_receive(:shorten).with("http://hyewye.com/").and_return(@shorten)
      @tweet.shorten("http://hyewye.com/")
    end
 
    it "returns the shortened url" do
      @tweet.shorten("http://hyewye.com/").should == @shorten.urls
    end
  end
end













