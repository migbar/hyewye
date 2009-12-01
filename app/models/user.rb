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
  
  attr_accessible :password, :password_confirmation

  before_save :populate_oauth_user

  def to_s
    name || login
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def using_twitter?
    !oauth_token.blank?
  end

  private

    def populate_oauth_user
      return unless twitter_uid.blank?
      
      if using_twitter?
        @response = UserSession.oauth_consumer.request(:get, '/account/verify_credentials.json',
        access_token, { :scheme => :query_string })
        case @response
        when Net::HTTPSuccess
          user_info = JSON.parse(@response.body)

          self.name        = user_info['name']
          self.twitter_uid = user_info['id']
          self.avatar_url  = user_info['profile_image_url']
        end
      end
    end

end
