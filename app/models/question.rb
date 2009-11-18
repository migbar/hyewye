# == Schema Information
# Schema version: 20091111111409
#
# Table name: questions
#
#  id            :integer(4)      not null, primary key
#  user_id       :integer(4)
#  body          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  answers_count :integer(4)      default(0)
#

class Question < ActiveRecord::Base
  include Behaviours::CreateEvent

  validates_presence_of :body
  validates_length_of   :body, :maximum => 140

  belongs_to :user
  has_one :event, :as => :subject
  has_many :answers do
    def i_have_percent;        size > 0 ? i_have.count         * 100 / size : 0; end
    def i_would_percent;       size > 0 ? i_would.count        * 100 / size : 0; end
    def i_would_never_percent; size > 0 ? i_would_never.count  * 100 / size : 0; end
  end
  
  def i_have_percent
    Rails.cache.fetch(percentage_cache_key(:i_have_percent)) { answers.i_have_percent }
  end

  def i_would_percent
    Rails.cache.fetch(percentage_cache_key(:i_would_percent)) { answers.i_would_percent }
  end

  def i_would_never_percent
    Rails.cache.fetch(percentage_cache_key(:i_would_never_percent)) { answers.i_would_never_percent }
  end
  
  def expire_percentages_cache
    Rails.cache.fetch(percentage_cache_key(:i_have_percent), :force => true) { nil }
    Rails.cache.fetch(percentage_cache_key(:i_would_percent), :force => true) { nil }
    Rails.cache.fetch(percentage_cache_key(:i_would_never_percent), :force => true) { nil }
  end
  
  def answer_created
    expire_percentages_cache
  end
  
  def percentage_cache_key(choice)
    "question:#{id}:#{choice}"
  end
  
  def to_s
    body
  end
end
  
