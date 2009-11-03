Given /^the following questions and answers exist$/ do |events|
  events.hashes.each do |hash|
    factory = hash.delete("model")
    since = hash.delete("since")
    Factory.create(factory, hash.merge("created_at" => since.to_i.minutes.ago))
  end
end

Then /^I should see the following events$/ do |expected_table|
  actual_table = table(table_at('#stream').to_table)
  # actual_table.map_column!('Event') { |text|
  #    puts text
  #    # text.strip.match(/>(.*)</)[1]
  #    
  #    text
  #  }
   # ... more columns
  expected_table.diff!(actual_table)
end