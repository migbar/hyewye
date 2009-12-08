Factory.define(:twitter_user, :class => User) do |f|
  f.sequence(:name) {|i| "twitter_guy_#{i}"}
  f.sequence(:twitter_uid) {|i| i}
  f.avatar_url {|twitter_user| "http://a3.twimg.com/profile_images/#{twitter_user.twitter_uid}/images-2_normal.jpeg"}
  f.oauth_token {|twitter_user| "#{twitter_user.name}_token"}
  f.oauth_secret {|twitter_user| "#{twitter_user.name}_secret"}
end

Factory.define(:user) do |f|
  f.sequence(:login) { |i| "user-#{i}" }
  f.email { |u| "#{u.login}@example.com" }
  f.password "secret"
  f.password_confirmation { |u| u.password }
end

Factory.define(:question) do |f|
  f.sequence(:body) {|i| "bet #{i} dollars on blackjack"}
  f.association(:user)
end

Factory.define(:answer) do |f|
  f.sequence(:body) {|i| "answer #{i}"}
  f.sequence(:choice) { (rand() * 3).to_i + 1 }
  f.association(:question)
  f.association(:user)
end

Factory.define(:event) do |f|
end

Factory.define(:question_event, :parent => :event) do |f|
  f.association(:subject, :factory => :question)
end

Factory.define(:answer_event, :parent => :event) do |f|
  f.association(:subject, :factory => :answer)
end
