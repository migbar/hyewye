miguel = User.create_or_update(:id => 1, :login => 'miguel', :email => 'miguel@example.com', :password => 'secret', :password_confirmation => 'secret')
istvan = User.create_or_update(:id => 2, :login => 'istvan', :email => 'istvan@example.com', :password => 'secret', :password_confirmation => 'secret')

question = Question.create_or_update(:id => 1, :user => miguel, :body => 'Have plastic surgery?')
Answer.create_or_update(:id => 1, :user => istvan, :question => question, :choice => 3, :body => 'Nope!')