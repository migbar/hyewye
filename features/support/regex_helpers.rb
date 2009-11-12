module RegexHelpers
  CHOICE_REGEX = /I (Have|Would Never|Would)/
  BODY_REGEX = /[a-zAZ]+-\d+/
  
  def choice_regex
    CHOICE_REGEX
  end
  
  def body_regex
    BODY_REGEX
  end
end

World(RegexHelpers)