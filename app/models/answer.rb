# == Schema Information
# Schema version: 20091111111409
#
# Table name: answers
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  question_id :integer(4)
#  choice      :integer(4)
#  body        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Answer < ActiveRecord::Base
  include Behaviours::CreateEvent
  after_create :notify_question
  
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
  has_one :event, :as => :subject
  
  validates_presence_of :body
  validates_length_of :body, :maximum => 255
  validates_inclusion_of :choice, :in => choices.values, :message => "please select one"
  
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
  
  private
    def notify_question
      question.answer_created
    end
end

