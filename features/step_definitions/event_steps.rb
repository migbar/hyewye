Given /^the following questions and answers exist$/ do |events|
  events.hashes.each do |hash|
    factory = hash.delete("model")
    since = hash.delete("since")
    login = hash.delete("user")
    user = User.find_by_login(login) || Factory.create(:user, :login => login)
    Factory.create(factory, hash.merge("user" => user, "created_at" => since.to_i.minutes.ago))
  end
end

Then /^I should see the following events$/ do |expected_table|
  actual_table = table(table_at('#stream').to_table)
  actual_table.map_column!('User') { |text|
    text.strip.match(/>(.*)</)[1]
  }
  # ... more columns
  expected_table.diff!(actual_table)
end