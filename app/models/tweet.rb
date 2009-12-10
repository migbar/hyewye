class Tweet
  include ActionController::UrlWriter
  include ActionView::Helpers::TextHelper
  
  MAXIMUM_TWEET_SIZE = 140
  HASHTAG = "#hyewye"
  
  attr_accessor :type, :param, :subject_body, :screen_name, :choice
  
  def initialize(subject)
    self.type          = subject.class.name
    self.subject_body  = subject.body
    
    case type
    when "Question"
      self.param       = subject.to_param
    when "Answer"
      self.param       = subject.question.to_param
      self.screen_name = subject.question.user.screen_name
      self.choice      = subject.choice_name
    end
  end
  
  def url
    @url ||= question_answers_url(param, :host => Settings.host)
  end
  
  def body(joined_values)
    truncate(subject_body, :length => trimmed_size(joined_values))
  end
  
  def to_s
    case type
    when "Question"
      joined_values = [HASHTAG, url]
      "#{HASHTAG} #{body(joined_values)} #{url}"
    when "Answer"
      joined_values = [HASHTAG, url, "#{choice},", "@#{screen_name}"]
      
      "@#{screen_name} #{choice}, #{body(joined_values)} #{HASHTAG} #{url}"
    end
  end
  
  private
    def trimmed_size(joined_values)
      MAXIMUM_TWEET_SIZE - (joined_values.sum(&:size) + joined_values.size)
    end
end