# == Schema Information
#
# Table name: invitations
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Invitation < ActiveRecord::Base
  validates_format_of :email, :with => Authlogic::Regex.email, :message => "is not an email"
  
  after_create :deliver_invitation_notification!
  
  def deliver_invitation_notification!
    Notifier.deliver_invitation_notification(self)
  end
end
