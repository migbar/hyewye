require 'rubygems'
require 'cucumber'
require 'cucumber/ast/table'

Given /^the following answers exist for #{capture_model}$/ do |capture, answers|
  question = model(capture)
  answers.hashes.each do |hash|
    since = hash.delete("since")
    login = hash.delete("user")
    user = User.find_by_login(login) || Factory.create(:user, :login => login)
    Factory.create(:answer, hash.merge("user" => user, "question" => question, "created_at" => since.to_i.minutes.ago))
  end
end

# Then /^I should see the following answers$/ do |expected_table|
#   actual_table = table(table_at('#answers-list').to_table)
#   actual_table.map_column!("User")  do |text|
#     text.strip.match(/>(.*)</)[1]
#   end
#   expected_table.diff!(actual_table)
# end

Then /^I should see the following answers$/ do |expected_table|
  actual_table = table(table_at('#answers-list').to_table)
  hand_made = [%w{User Choice Answer}]  
  actual_table.raw.each do |row|
    puts row
    user = row[0].strip.match(/>(.*)</)[1]
    choice = row[0].strip.match(/I Have|I Would Never|I Would/)[0] # Awful regexp matching, order of options is brittle
    answer = row[0].strip.match(/a1|a2|a3|a4|a5|a6|a7|a8|a9/)[0] # More awful matching based on known values instead of position
    hand_made = hand_made + [[user, choice, answer]]
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
