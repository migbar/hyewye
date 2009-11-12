class Answer < ActiveRecord::Base
  include Behaviours::CreateEvent
  
  CHOICES = {
    :i_have        => 1,
    :i_would       => 2,
    :i_would_never => 3
  }
  
  class << self
    def choices
      CHOICES
    end
  end
  
  belongs_to :user
  belongs_to :question, :counter_cache => true
  has_one :event, :as => :target
  
  validates_presence_of :body
  validates_length_of :body, :maximum => 140
  validates_inclusion_of :choice, :in => choices.values
  
  named_scope :latest, :order => "answers.created_at DESC"
  
  choices.each do |choice, value|    
    named_scope choice, :conditions => { :choice => value }
  end
  
  def to_s
    body
  end
  
  def choice_name
    ["I Have", "I Would", "I Would Never"][choice-1]
  end
end

