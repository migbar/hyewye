class Question < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :body
  validates_length_of   :body, :maximum => 140
  has_many :answers
end
