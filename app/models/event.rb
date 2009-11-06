class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true
  named_scope :latest, lambda {
    since = 1.hour.ago
    
    { :conditions => ["events.created_at >= ?", since],
      :order => "events.created_at DESC"
    }
  }
  
end
