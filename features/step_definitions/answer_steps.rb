Given /^the following answers exist for #{capture_model}$/ do |capture, answers|
  question = model(capture)
  answers.hashes.each do |hash|
    since = hash.delete("since")
    Factory.create(:answer, hash.merge("question" => question, "created_at" => since.to_i.minutes.ago))
  end
end

Then /^I should see the following answers$/ do |expected_table|
  actual_table = table(table_at('#answers').to_table)
  expected_table.diff!(actual_table)
end