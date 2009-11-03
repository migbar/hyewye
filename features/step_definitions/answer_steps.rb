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
  actual_table = table(table_at('#answers').to_table)
  actual_table.map_column!("User")  do |text|
    text.strip.match(/>(.*)</)[1]
  end
  expected_table.diff!(actual_table)
end