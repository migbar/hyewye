# == Schema Information
#
# Table name: events
#
#  id           :integer(4)      not null, primary key
#  subject_id   :integer(4)      indexed => [subject_type], indexed
#  subject_type :string(255)     indexed => [subject_id], indexed
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :integer(4)      indexed
#

class Event < ActiveRecord::Base
  attr_writer :notify_user
  
  belongs_to :user
  belongs_to :subject, :polymorphic => true
  named_scope :latest, lambda { |*args|
    limit = args.first
    { :limit => limit,
      :order => "events.created_at DESC"
    }
  }
  
  after_create :notify_user
  
  def self.with_notify_user(&block)
    with_scope(:create => { :notify_user => true }) do
      yield
    end
  end
  
  def notify_user?
    @notify_user
  end
  
  private
    def notify_user
      user.event_created(subject) if notify_user?
    end
  
end
