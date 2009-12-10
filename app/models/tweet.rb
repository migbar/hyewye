class Tweet
  include ActionController::UrlWriter
  include ActionView::Helpers::TextHelper
  
  MAXIMUM_TWEET_SIZE = 140
  HASHTAG = "#hyewye"
  
  attr_reader :subject
  
  def initialize(subject)
    @subject = subject
  end
  
  def to_s
    case subject
    when Question
      url           = question_answers_url(subject, :host => Settings.host)
      joined_values = [HASHTAG, url]
      body          = truncate(subject.body, :length => trimmed_size(joined_values))
      
      "#{HASHTAG} #{body} #{url}"
    when Answer
      url           = question_answers_url(subject.question, :host => Settings.host)
      choice        = subject.choice_name
      screen_name   = subject.question.user.screen_name
      joined_values = [HASHTAG, url, "#{choice},", "@#{screen_name}"]
      body          = truncate(subject.body, :length => trimmed_size(joined_values))
      
      "@#{screen_name} #{choice}, #{body} #{HASHTAG} #{url}"
    end
  end
  
  private
    def trimmed_size(joined_values)
      MAXIMUM_TWEET_SIZE - (joined_values.sum(&:size) + joined_values.size)
    end
end