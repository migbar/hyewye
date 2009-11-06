module Behaviours::CreateEvent
  def self.included(base)
    base.send(:after_create, :create_event_with_user_and_timestamp)
  end
  
  private
    def create_event_with_user_and_timestamp
      create_event(:user_id => user_id, :created_at => created_at)
    end
end