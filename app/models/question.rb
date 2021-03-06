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
  
  HOTNESS_COEFFICIENT = 3600
  DECREASE_THRESHOLD = 3600 * 24 * 7

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
      :conditions => "#{Question.table_name}.answers_count > 0",
      :limit     => limit }
  }
  
  before_create :set_hotness_decreased_at
  
  class << self
    def for_sidebar
      hottest(5).sort_by { rand }.first
    end
    
    def update_hotness
      Question.all.each(&:recalculate_hotness)
    end
    
    def decrease_hotness
      Question.update_all("hotness = hotness * 0.95, hotness_decreased_at = '#{Time.now.utc.to_s(:db)}'", ["hotness_decreased_at IS NULL OR hotness_decreased_at < ?", DECREASE_THRESHOLD.seconds.ago.utc])
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
    send_later(:update_hotness_delayed, Time.now)
  end
  
  def update_hotness_delayed(now)
    update_hotness(now, last_answered_at || created_at)
    self.last_answered_at = now
    self.hotness_decreased_at = now
    save!
  end

  def update_hotness(now, before)
    # Additional considerations:
    # 1 - dont update hotness if the answer is from someone who's already answered it
    # 2 - take into consideration the "freshness" of the question too. Because we record hotness at the time of the answer,
    # it becomes a cached value, so effectively making it 'sticky' even long after a long time has passed. Should we consider
    # freshness as a condition(i.e., do not select hot but old questions) or as a order criteria (i.e., select only based on 
    # hotness but then use freshness to sort the old ones to the bottom)
    difference = now - before
    factor = difference < 1.0 ? 1.0 : (1 + Question::HOTNESS_COEFFICIENT / difference)
    self.hotness = hotness * factor
  end
  
  def recalculate_hotness
    prev = nil
    self.hotness = 1.0
    answers.each do |a|
      update_hotness(a.created_at, prev.try(:created_at) || self.created_at)
      prev = a
    end
    save!
  end
  
  def percentage_cache_key(choice)
    "question:#{id}:#{choice}"
  end
  
  def to_s
    body
  end
  
  private
  def set_hotness_decreased_at
    self.hotness_decreased_at = Time.now
  end
  
end
  
