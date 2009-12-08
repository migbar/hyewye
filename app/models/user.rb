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

  TWITTER_AVATAR_SIZE = "48"
  
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
  
  def avatar
    if using_twitter?
      avatar_url
    else
      gravatar_url(:size => TWITTER_AVATAR_SIZE)
    end
  end
  
  def gravatar_url(gravatar_options={})

    # Default highest rating.
    # Rating can be one of G, PG, R X.
    # If set to nil, the Gravatar default of X will be used.
    gravatar_options[:rating] ||= nil

    # Default size of the image.
    # If set to nil, the Gravatar default size of 80px will be used.
    gravatar_options[:size] ||= nil 

    # Default image url to be used when no gravatar is found
    # or when an image exceeds the rating parameter.
    gravatar_options[:default] ||= nil

    # Build the Gravatar url.
    grav_url = 'http://www.gravatar.com/avatar.php?'
    grav_url << "gravatar_id=#{Digest::MD5.hexdigest(email)}" 
    grav_url << "&rating=#{gravatar_options[:rating]}" if gravatar_options[:rating]
    grav_url << "&size=#{gravatar_options[:size]}" if gravatar_options[:size]
    grav_url << "&default=#{gravatar_options[:default]}" if gravatar_options[:default]
    return grav_url
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
