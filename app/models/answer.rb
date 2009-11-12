class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question, :counter_cache => true
  validates_presence_of :body
  validates_length_of :body, :maximum => 140
  validates_inclusion_of :choice, :in => 1..3
  has_one :event, :as => :target
  named_scope :latest, :order => 'created_at DESC'
  include Behaviours::CreateEvent
end
