# == Schema Information
#
# Table name: questions
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)      indexed
#  body             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  answers_count    :integer(4)      default(0)
#  hotness          :float           default(0.0)
#  last_answered_at :datetime
#

class Question < ActiveRecord::Base
  include Behaviours::CreateEvent

  validates_presence_of :body
  validates_length_of   :body, :maximum => 255

  belongs_to :user
  has_one :event, :as => :subject
  has_many :answers do
    def i_have_percent;        size > 0 ? i_have.count         * 100 / size : 0; end
    def i_would_percent;       size > 0 ? i_would.count        * 100 / size : 0; end
    def i_would_never_percent; size > 0 ? i_would_never.count  * 100 / size : 0; end
  end
  
  named_scope :hottest, lambda { |limit|
    { :order     => "#{Question.table_name}.hotness DESC",
      :conditions => "#{Question.table_name}.hotness > 0",
      :limit     => limit }
  }
  
  class << self
    def for_sidebar
      hottest(5).sort_by { rand }.first
    end
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
    # update_hotness
    # self.last_answered_at = Time.now
    # save!
  end
  
  # def update_hotness
  # # Additional considerations:
  # # 1 - dont update hotness if the answer is from someone who's already answered it
  # # 2 - take into consideration the "freshness" of the question too. Because we record hotness at the time of the answer,
  # # it becomes a cached value, so effectively making it 'sticky' even long after a long time has passed. Should we consider
  # # freshness as a condition(i.e., do not select hot but old questions) or as a order criteria (i.e., select only based on 
  # # hotness but then use freshness to sort the old ones to the bottom)
  
  #   k = 1000
  #   initial_hotness = 1
  #   self.hotness = (hotness > 0 ? hotness : initial_hotness) * k / (Time.now - last_answered_at)
  # end
  
  def percentage_cache_key(choice)
    "question:#{id}:#{choice}"
  end
  
  def to_s
    body
  end
end
  
