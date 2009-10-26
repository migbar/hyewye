class Question < ActiveRecord::Base
  belongs_to :user
  validates_length_of :body, :maximum => 140
  validates_presence_of :body
end
