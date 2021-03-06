# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)     indexed
#  email               :string(255)     indexed
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)     not null, indexed
#  single_access_token :string(255)     not null, indexed
#  perishable_token    :string(255)     not null, indexed
#  created_at          :datetime
#  updated_at          :datetime
#  twitter_uid         :string(255)
#  avatar_url          :string(255)
#  name                :string(255)
#  oauth_token         :string(255)     indexed
#  oauth_secret        :string(255)
#  screen_name         :string(255)
#  location            :string(255)
#  tweet_activity      :boolean(1)      default(TRUE)
#

require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  should_have_column :login, :email, :crypted_password, :password_salt,
                     :persistence_token, :single_access_token, :perishable_token, 
                     :name, :screen_name, :avatar_url, :twitter_uid, :location,
                     :type => :string
  should_have_many :questions
  should_have_many :answers
  should_have_many :events
  
  it "#to_s returns the login for the user" do
    user = User.new
    user.login = "bob"
    user.to_s.should == 'bob'
  end
  
  describe "#deliver_password_reset_instructions!" do
    before(:each) do
      @user = Factory.create(:user)
      Notifier.stub(:deliver_password_reset_instructions)
    end

    it "resets the perishable token" do
      @user.should_receive(:reset_perishable_token!)
      @user.deliver_password_reset_instructions!
    end

    it "delivers the password reset instructions using the Notifier" do
      Notifier.should_receive(:deliver_password_reset_instructions).with(@user)
      @user.deliver_password_reset_instructions!
    end
  end
  
  describe "#avatar" do
    it "returns #avatar_url if using Twitter" do
      user = Factory.build(:twitter_user)
      user.avatar.should == user.avatar_url
    end
    
    it "returns the #gravatar_url sized like the Twitter avatar if not using Twitter" do
      user = Factory.build(:user)
      user.avatar.should == user.gravatar_url(:size => User::TWITTER_AVATAR_SIZE)
    end
  end
  
  describe "#gravatar_url" do
    it "returns the gravatar URL based on the user's email" do
      user = Factory.build(:user)
      user.gravatar_url.should match(/www.gravatar.com/)
    end
  end
  
  describe "#event_created" do
    it "calls #tweet_event if tweet_activity event is set" do
      question = Factory.build(:question)
      user = Factory.build(:user)
      user.should_receive(:tweet_event)
      user.event_created(question)
    end
    
    it "does not call #tweet_event if tweet_activity is not set" do
      question = Factory.build(:question)
      user = Factory.build(:twitter_user, :tweet_activity => false)
      user.should_not_receive(:tweet_event)
      user.event_created(question)
    end
  end
  
  describe "#tweet_event" do
    it "builds a tweet for the creation of an event and tweets it if the user is using twitter" do
      tweet = mock("tweet")
      question = Factory.build(:question)
      user = Factory.build(:twitter_user)
      user.should_receive(:tweet).with(question)
      user.tweet_event(question)
    end
    
    it "does not tweet if the user is not a twitter user" do
      question = Factory.build(:question)
      user = Factory.build(:user)
      Tweet.should_not_receive(:new)
      user.should_not_receive(:tweet)
      user.tweet_event(question)
    end
  end
  
  
  it "#tweet enqueues perform_twitter_update" do
    @user = Factory.build(:twitter_user)
    @user.should_receive(:send_later).with(:perform_twitter_update, "the status")
    @user.tweet("the status")
  end
  
  describe "#perform_twitter_update" do
    before(:each) do
      @client = mock("TwitterOAuth::Client", :update => nil, :authorized? => true)
      TwitterOAuth::Client.stub!(:new).and_return(@client)
      @user = Factory.build(:twitter_user)
      @question = mock_model(Question, :body => "Foo")
      @tweet = mock(Tweet, :to_s => "this is my status")
      Tweet.stub(:new).and_return(@tweet)
    end
    
    it "builds a Twitter auth client with the consumer and user credentials" do
      TwitterOAuth::Client.should_receive(:new).
        with(:consumer_key => Settings.twitter.consumer_key,
             :consumer_secret => Settings.twitter.consumer_secret,
             :token => @user.oauth_token, 
             :secret => @user.oauth_secret).
        and_return(@client)
      @user.perform_twitter_update(@question)
    end
    
    it "build a Tweet from the subject if authorized" do
      @client.should_receive(:authorized?).and_return(true)
      Tweet.should_receive(:new).with(@question).and_return(@tweet)
      @user.perform_twitter_update(@question)
    end
    
    it "updates the status of the Twitter user using the OAuth client if authorized" do
      @client.should_receive(:authorized?).and_return(true)
      @client.should_receive(:update).with(@tweet.to_s)
      @user.perform_twitter_update(@question)
    end
    
    it "does not try to update the status if client is not authorized" do
      @client.should_receive(:authorized?).and_return(false)
      @client.should_not_receive(:update).with(@tweet.to_s)
      @user.perform_twitter_update(@question)
    end
  end

  describe "populate user data from Twitter profile" do
    describe "on save" do
      it "does not overwrite existing data" do
        user = Factory.create(:twitter_user)
        UserSession.oauth_consumer.should_not_receive(:request)
        user.save
      end
    end
    
    describe "on create" do
      before(:each) do
        @user = Factory.build(:twitter_user, :twitter_uid => nil)
        @user.stub!(:access_token).and_return("the-access-token")
        @twitter_response = mock("Twitter HTTP Response", :body => "{}")
        UserSession.stub_chain(:oauth_consumer, :request).and_return(@twitter_response)
      end
      
      it "does nothing if not using Twitter" do
        user = Factory.build(:user)
        UserSession.oauth_consumer.should_not_receive(:request)
        user.save
      end
      
      it "fetches the user profile information from Twitter if using OAuth" do
        UserSession.oauth_consumer.
          should_receive(:request).
          with(:get, '/account/verify_credentials.json', @user.send(:access_token), { :scheme => :query_string }).
          and_return(@twitter_response)
        
        @user.save
      end
      
      it "sets the user's attributes to the ones in the user's Twitter profile" do
        attribute_mapping = {
          :name => "name",
          :id => "twitter_uid",
          :screen_name => "screen_name",
          :location => "location",
          :profile_image_url => "avatar_url"
        }
        
        fetched_attributes = {
          :name => "Twitter Guy",
          :screen_name => "twitter_guy",
          :id => "123456",
          :profile_image_url => "http://twitter.com/123456/avatar.png",
          :location => "NY"
        }
        
        @twitter_response.should_receive(:is_a?).and_return(true)
        @twitter_response.stub!(:body).and_return(fetched_attributes.to_json)
        
        fetched_attributes.each do |key, value|
          @user.should_receive("#{attribute_mapping[key]}=").with(value)
        end
        
        @user.save
      end
      
      
    end
  end
end

