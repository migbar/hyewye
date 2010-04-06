require 'email_spec/cucumber'

World(ActionView::Helpers::RecordIdentificationHelper)
World(ActionView::Helpers::UrlHelper)
World(Authlogic::TestCase)

Before do
  activate_authlogic
end

After do |scenario|
  TwitterQueue.reset
  
  if scenario.failed?
    # save_and_open_page
  end
end

FakeWeb.allow_net_connect = false

# require 'features/support/regex_helpers'
# require 'features/support/pickle'
