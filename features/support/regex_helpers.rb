module RegexHelpers
  CHOICE_REGEX = /I (Have|Would Never|Would)/
  
  def choice_regex
    CHOICE_REGEX
  end
end

World(RegexHelpers)