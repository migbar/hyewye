require File.dirname(__FILE__) + '/../spec_helper'

describe Tweet do
  include ActionController::UrlWriter
  
  describe "#to_s" do
    before(:each) do
      @question = mock_question(:body => "Short Question")
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
        tweet_str.size.should == 138
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
        tweet_str.size.should == 139
        escaped_url = Regexp.escape(tweet.url)
        tweet_str.should =~ /^@#{@user.screen_name} #{@answer.choice_name}, Foo bar.+?\.{3} #hyewye #{escaped_url}$/
      end
    end
  end
  
  describe "#url" do
    before(:each) do
      @question = mock_question(:body => "have plastic surgery?", :to_param => "4")
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
      @body_without_links = "A" * 140
      @question = mock_question(:body => "http://example.com " + @body_without_links)
      
      @tweet = Tweet.new(@question)
    end
    
    it "truncates the subject body without link to fit within trimmed size" do
      @tweet.should_receive(:trimmed_size).with(%w[foo bar baz]).and_return(128)
      @tweet.should_receive(:subject_body_without_links).and_return("subject body without links")
      @tweet.should_receive(:truncate_words).with("subject body without links", 128).and_return("truncated body")
      @tweet.body(%w[foo bar baz]).should == "truncated body"
    end
    
    it "strips out the links from tbe body" do
      @tweet.body(%w[foo]).should_not include("http://example.com")
    end
  end
  
  describe "#bitly_authorization" do
    it "builds a bitly authorization with the login and key and returns it" do
      @question = mock_question(:body => "A" * 140, :to_param => "4")
      @tweet = Tweet.new(@question)
      UrlShortener::Authorize.should_receive(:new).with(Settings.bitly.login, Settings.bitly.api_key).and_return("authorization")
      @tweet.bitly_authorization.should == "authorization"
    end
  end
  
  describe "#shorten" do
    before(:each) do
      @question = mock_question(:body => "A" * 140)
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
  
  describe "#subject_body_without_links" do
    before(:each) do
      @question = mock_question(:body => "use aperture instead of lightroom? http://news.cnet.com/8301-13580_3-9875221-39.html #photo #photoshop #aperture #lightroom")
      @tweet = Tweet.new(@question)
    end
    
    it "strips out any links from the body" do
      @tweet.subject_body_without_links.should == "use aperture instead of lightroom? #photo #photoshop #aperture #lightroom"
    end
  end
  
  describe "#truncate_words" do
    before(:each) do
      @tweet = Tweet.new(mock_question)
    end
    it "does nothing if size does not esceed limit" do
      @tweet.truncate_words("foo bar", 10).should == "foo bar"
    end
    
    it "truncates the first word if it exceeds the limit" do
      @tweet.truncate_words("foobar", 5).should == "fo..."
    end
    
    (23..29).each do |limit|
      it "truncate 'this is a really long sentence' with limit #{limit} on word boundary" do
        @tweet.truncate_words("this is a really long sentence", limit ).should == "this is a really long..."
      end
    end
  end
  
  def mock_question(stubs={})
    @mock_question ||= mock_model(Question, {:body => "foo http://example.com bar"}.merge(stubs))
  end
end













