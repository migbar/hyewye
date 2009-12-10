Given /^a Twitter user "([^\"]*)" registered with HyeWye$/ do |name|
  Given %Q{a twitter user "#{name}" exists with oauth_token: "foo", oauth_secret: "secret", screen_name: "#{name}", name: "#{name}", avatar_url: "http://a3.twimg.com/profile_images/63673063/images-2_normal.jpeg"}
  
  UserSession.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.attempted_record = User.find_by_oauth_token("foo")
    end
  end
  
  User.class_eval do
    def tweet(status)
      TwitterQueue.add(screen_name, status)
    end
  end
end

Given /^a Twitter user "([^\"]*)" that is not registered with HyeWye$/ do |twitter_name|
  # Factory.create(:user, :oauth_token => "foo", :oauth_secret => "secret", :name => name)
  
  UserSession.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.errors.add_to_base("Could not find user in our database")
    end
  end
  
  User.class_eval do
    define_method("user_twitter_name") do
      twitter_name
    end
    
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/account?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.twitter_uid = "12355434"
      self.name = user_twitter_name
      self.oauth_token = "foo"
      self.oauth_secret = "bar"
    end
  end
end

Given /^a Twitter user that denies access to HyeWye$/ do
  UserSession.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?denied=foo"
    end
  end
  
  User.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/account?denied=foo"
    end
 end
end


Given /^I log in using Twitter$/ do
 Given "I am on the login page"
 When "I press \"Let me log in using Twitter\""
end

Then /^I should see the Twitter avatar for #{capture_model}$/ do |capture|
  user = model(capture)
  response.should have_tag("img[src=?]", user.avatar_url)
end

Then /^I should see the Gravatar for #{capture_model}$/ do |capture|
  user = model(capture)
  response.should have_tag("img[src=?]", ERB::Util.h(user.gravatar_url(:size => User::TWITTER_AVATAR_SIZE)))
end

Given /^I am a logged in as the Twitter user "([^\"]*)"$/ do |name|
   Given %Q{a Twitter user "#{name}" registered with HyeWye}
   Given %Q{I am on the login page}
   Given %Q{I press "Let me log in using Twitter"}
end

Then /^"([^\"]*)" should have a tweet$/ do |name|
  # { "twitter_guy" => [ :body => "#hyewye have plastic..." ] }
  guy_queue = TwitterQueue.for_user(name)
  guy_queue.size.should == 1
  @twitter_guy = name
end

Then /^the tweet should contain "([^\"]*)"$/ do |text|
  @the_tweet = TwitterQueue.for_user(@twitter_guy).shift
  @the_tweet.should match(/#{text}/)
end

When /^I click the first link in the tweet$/ do
  link = URI.extract(@the_tweet).first
  visit link
end







