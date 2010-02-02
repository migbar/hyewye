def body
 "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever "
end

require 'user'
class User
  def authenticating_with_oauth?
    false
  end
end

miguel = User.create_or_update(:id => 1, :login => 'miguel', :email => 'miguel@example.com', :password => 'secret', :password_confirmation => 'secret')
istvan = User.create_or_update(:id => 2, :login => 'istvan', :email => 'istvan@example.com', :password => 'secret', :password_confirmation => 'secret')

question = Question.create_or_update(:id => 1, :user => miguel, :body => 'Have plastic surgery?')
(1..30).each do |i|
  Answer.create_or_update(:id => i, :user => [istvan, miguel][(rand()*2).to_i], :question => question, :choice => (rand() * 3).to_i + 1, :body => "#{body} ##{i}")
end