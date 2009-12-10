Given /^the following answers exist for #{capture_model}$/ do |capture, answers|
  question = model(capture)
  answers.hashes.each do |hash|
    since = hash.delete("since")
    login = hash.delete("user")
    user = User.find_by_login(login) || Factory.create(:user, :login => login)
    Factory.create(:answer, hash.merge("user" => user, "question" => question, "created_at" => since.to_i.minutes.ago))
  end
end

Then /^I should see the following answers$/ do |expected_table|
  doc = Nokogiri::HTML(response.body) 
  hand_made = [%w{User Choice Answer}]  
  doc.css('#answers-list .event .event-body').each do |answer_body|
    user = answer_body.css('a').first.content
    choice = answer_body.content[choice_regex, 0]
    body = answer_body.content[body_regex, 0]
    hand_made << [user, choice, body]
  end
  my_table = Cucumber::Ast::Table.new(hand_made)
  expected_table.diff!(my_table)
end

Given /^(\d+) answers exist for #{capture_model}$/ do |quantity, capture|
  question = model(capture)
  (1..quantity.to_i).each do |index|
    Factory.create(:answer, "question" => question, "body" => "Answer-#{index}", "created_at" => index.minutes.ago)
  end
  
end
