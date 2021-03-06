When /^I follow "([^\"]*)" for #{capture_model}$/ do |link, capture|
  record = model(capture)
  click_link_within("##{dom_id(record)}", link)
end

When /^I navigate to (.+?) for #{capture_model}$/ do |page_name, capture|
  record = model(capture)
  visit resource_to(page_name, record)
end

Then /^I should be at (.+?) for #{capture_model}$/ do |page_name, capture|
  record = model(capture)
  URI.parse(current_url).path.should == resource_to(page_name, record)
end

Then /^I should see the following:?$/ do |table|
  table.rows.each do |row|
    response.should contain(row.first)
  end
end

Then /^I should see a link to "([^\"]*)"$/ do |url|
  response.body.should =~ /href="#{Regexp.escape(url)}"/
end
