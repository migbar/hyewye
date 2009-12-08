module Behaviours::CreateEvent
  def self.included(base)
    base.send(:after_create, :create_event_with_user_and_timestamp)
  end
  
  def save_with_notification
    Event.with_notify_user do
      save
    end
  end
  
  private
    def create_event_with_user_and_timestamp
      create_event(:user => user, :created_at => created_at)
    end
end