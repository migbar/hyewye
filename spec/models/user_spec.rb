require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  should_have_column :login, :email, :crypted_password, :password_salt,
                     :persistence_token, :single_access_token, :perishable_token,
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
end

