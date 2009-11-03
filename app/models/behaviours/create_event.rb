module Behaviours::CreateEvent
  def self.included(base)
    base.send(:after_create, :create_event_with_timestamp)
  end
  
  private
    def create_event_with_timestamp
      create_event(:created_at => created_at)
    end
end