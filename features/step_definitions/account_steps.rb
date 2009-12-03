Given /^I log in with login: "([^\"]*)", password: "([^\"]*)"$/ do |login, password|
  user = User.find_by_login(login) || Factory.create(:user, :login => login, :password => password)
  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "#{password}"}
   And %Q{I press "Log in"}
end

Given /^I am logged in$/ do
  Given %Q{I log in with login: "my_login", password: "secret"}
end

Given /^a Twitter user "([^\"]*)" registered with HyeWye$/ do |name|
  Factory.create(:user, :oauth_token => "foo", :oauth_secret => "secret", :name => name)
  
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