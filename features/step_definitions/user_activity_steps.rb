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
  actual_table = table(table_at('#stream').to_table)
  expected_table.diff!(actual_table)
end

Then /^I should not see the following events$/ do |table|
  table.hashes.each do |hash|
    response.should_not contain(hash["Event"])
  end
end