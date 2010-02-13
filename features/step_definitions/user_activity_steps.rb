Given /^the following questions and answers exist for #{capture_model}$/ do |capture, table|
  user = model(capture)
  table.hashes.each do |hash|
    factory = hash.delete("model")
    since = hash.delete("since")
    # user = User.find_by_login(login) || Factory.create(:user, :login => login)
    Factory.create(factory, hash.merge("user" => user, "created_at" => since.to_i.minutes.ago))
  end
end

Then /^I should see the following events$/ do |expected_table|
  doc = Nokogiri::HTML(response.body) 
  hand_made = [%w{Event}]  
  doc.css('#stream .event .body').each do |element|
    hand_made << [element.content.strip]
  end
  my_table = Cucumber::Ast::Table.new(hand_made)
  expected_table.diff!(my_table)
end

Then /^I should not see the following events$/ do |table|
  table.hashes.each do |hash|
    response.should_not contain(hash["Event"])
  end
end