class Question < ActiveRecord::Base
  include Behaviours::CreateEvent

  validates_presence_of :body
  validates_length_of   :body, :maximum => 140

  belongs_to :user
  has_one :event, :as => :target
  has_many :answers do
    def i_have_percent;        size > 0 ? i_have.count         * 100 / size : 0; end
    def i_would_percent;       size > 0 ? i_would.count        * 100 / size : 0; end
    def i_would_never_percent; size > 0 ? i_would_never.count  * 100 / size : 0; end
  end
  
  delegate :i_have_percent, :i_would_percent, :i_would_never_percent, :to => :answers
  
  def to_s
    body
  end
end
  
