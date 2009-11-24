require 'spec_helper'

describe Invitation do
  describe "structure" do
    should_have_column :email
  end
  
  describe "validations" do
    should_allow_values_for :email, "foo@example.com", "foo.bar@example.com"
    should_not_allow_values_for :email, "foo", "", "..."
  end
  
  describe "after_create" do
    it "delivers a notification" do
      invitation = Invitation.new(:email => "foo@example.com")
      Notifier.should_receive(:deliver_invitation_notification).with(invitation)
      invitation.save
    end
  end
end
