Given /^the following questions and answers exist$/ do |events|
  events.hashes.each do |hash|
    factory = hash.delete("model")
    since = hash.delete("since")
    login = hash.delete("user")
    user = User.find_by_login(login) || Factory.create(:user, :login => login)
    Factory.create(factory, hash.merge("user" => user, "created_at" => since.to_i.minutes.ago))
  end
end

Then /^I should see the following users and events$/ do |expected_table|
  doc = Nokogiri::HTML(response.body) 
  hand_made = [%w{user body}]  
  doc.css('#events-list #event #event-body').each do |event|
    user = event.css('a').first.content
    body = event.content[body_regex, 0]
    hand_made << [user, body]
  end
  my_table = Cucumber::Ast::Table.new(hand_made)
  expected_table.diff!(my_table)
end