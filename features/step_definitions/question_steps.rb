When /^I fill "([^\"]*)" with (\d+) characters$/ do |field, count|
  fill_in(field, :with => 'x' * count.to_i)
end