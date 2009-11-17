# == Schema Information
# Schema version: 20091117132515
#
# Table name: events
#
#  id           :integer(4)      not null, primary key
#  subject_id   :integer(4)
#  subject_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :integer(4)
#

class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, :polymorphic => true
  named_scope :latest, lambda {
    since = 1.hour.ago
    
    { :conditions => ["events.created_at >= ?", since],
      :order => "events.created_at DESC"
    }
  }
  
end
