require 'spec_helper'

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