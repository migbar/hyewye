module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    when /the site index/
      site_index_path
    when /the registration page/
      new_account_path
    when /the login page/
      new_user_session_path
    when /the ask question page/
      new_question_path
    when /my account page/
      edit_account_path
    when /the answers page for "([^\"]*)"/
      record = Question.find_by_body($1)
      question_answers_path(record)
      
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
  
  def resource_to(page_name, record)
    case page_name
    
    when /the model page/
      url_for(record)
    when /the answers page/
      question_answers_path(record)
    when /the questions page/
      user_questions_path(record)
    else
      raise "Can't find mapping from \"#{page_name}\" to a resource.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
