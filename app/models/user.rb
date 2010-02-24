# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)     indexed
#  email               :string(255)     indexed
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)     not null, indexed
#  single_access_token :string(255)     not null, indexed
#  perishable_token    :string(255)     not null, indexed
#  created_at          :datetime
#  updated_at          :datetime
#  twitter_uid         :string(255)
#  avatar_url          :string(255)
#  name                :string(255)
#  oauth_token         :string(255)     indexed
#  oauth_secret        :string(255)
#  screen_name         :string(255)
#  location            :string(255)
#  tweet_activity      :boolean(1)      default(TRUE)
#

class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :questions
  has_many :answers
  has_many :events
  
  attr_accessible :password, :password_confirmation, :name, :tweet_activity, :tos_agreement

  before_save :populate_oauth_user
  
  validates_acceptance_of :tos_agreement, :message => "You must accept the terms of service"

  TWITTER_AVATAR_SIZE = "48"
  
  def to_s
    name || login
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def using_twitter?
    !!oauth_token
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
  
  def event_created(subject)
    tweet_event subject if tweet_activity?
  end
  
  def tweet_event(subject)
    tweet(subject) if using_twitter?
  end
  
  def tweet(subject)
    send_later(:perform_twitter_update, subject)
  end
  
  def perform_twitter_update(subject)
    client = TwitterOAuth::Client.new(
        :consumer_key => Settings.twitter.consumer_key, 
        :consumer_secret => Settings.twitter.consumer_secret,
        :token => oauth_token, 
        :secret => oauth_secret
    )
    # raise "Does the job get rescheduled on exception?"
    client.update(Tweet.new(subject).to_s) if client.authorized?
  end

  private

    def populate_oauth_user
      return unless twitter_uid.blank?
      
      if using_twitter?
        @response = UserSession.oauth_consumer.request(:get, '/account/verify_credentials.json',
        access_token, { :scheme => :query_string })
        if @response.is_a?(Net::HTTPSuccess)
          user_info = JSON.parse(@response.body)

          self.name        = user_info['name']
          self.twitter_uid = user_info['id']
          self.avatar_url  = user_info['profile_image_url']
          self.screen_name = user_info['screen_name']
          self.location    = user_info['location']
        end
      end
    end

end
