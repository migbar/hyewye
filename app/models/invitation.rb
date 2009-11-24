class Invitation < ActiveRecord::Base
  validates_format_of :email, :with => Authlogic::Regex.email, :message => "is not an email"
  
  after_create :deliver_invitation_notification!
  
  def deliver_invitation_notification!
    Notifier.deliver_invitation_notification(self)
  end
end
