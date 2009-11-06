class User < ActiveRecord::Base
  acts_as_authentic
  has_many :questions
  has_many :answers
  has_many :events
end
