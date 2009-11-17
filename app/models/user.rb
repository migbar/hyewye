# == Schema Information
# Schema version: 20091111111409
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)     not null
#  email               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  created_at          :datetime
#  updated_at          :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic
  has_many :questions
  has_many :answers
  has_many :events
  
  def to_s
    login
  end
end
