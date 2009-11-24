require File.dirname(__FILE__) + '/../spec_helper'

describe Notifier do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include ActionController::UrlWriter
  
  describe "#password_reset_instructions" do
    before(:each) do
      @user = Factory.create(:user)
      @sent_time = 1.hour.ago
      @email = Notifier.create_password_reset_instructions(@user, @sent_time)
    end
    
    it "sets the subject" do
      @email.should have_subject("[HyeWye] Password reset instructions")
    end
    
    it "it sets the from field" do
      @email.from.should == ["no-reply@hyewye.com"]
    end
    
    it "sets the recipient to the user's email" do
      @email.should deliver_to(@user.email)
    end
    
    it "sets the delivery time" do
      @email.date.to_s(:db).should == @sent_time.to_s(:db)
    end
    
    it "contains the password reset url" do
      @email.should have_text(/#{edit_password_reset_url(:id => @user.perishable_token, :host => "example.com")}/)
    end
  end
  
  describe "#deliver_invitation_notification" do
    before(:each) do
      @invitation = Invitation.new(:email => "foo@example.com")
      @email = Notifier.create_invitation_notification(@invitation)
    end
    
    it "sets the subject" do
      @email.should have_subject("\[HyeWye\] Notification request")
    end
    
    it "sets the body" do
      @email.should have_text(/#{@invitation.email}/)
    end
    
    it "it sets the from field" do
      @email.from.should == ["no-reply@hyewye.com"]
    end
    
    it "sets the recipient to the user's email" do
      @email.should deliver_to("notifications@hyewye.com")
    end
  end
end
