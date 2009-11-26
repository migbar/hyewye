class UserSession < Authlogic::Session::Base
  def self.oauth_consumer
    OAuth::Consumer.new("DLdF4bL5BFCpgVLSY2niQ", "GjVRwnTiwDArWcq2GVVt3KCtBKhw1UNzz8OurLKAE",
    { :site=>"http://twitter.com",
      :authorize_url => "http://twitter.com/oauth/authenticate" })
  end
end