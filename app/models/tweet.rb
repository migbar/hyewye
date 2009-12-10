class Tweet
  include ActionController::UrlWriter
  include ActionView::Helpers::TextHelper
  
  MAXIMUM_TWEET_SIZE = 140
  HASHTAG = "#hyewye"
  
  attr_accessor :subject_type, :param, :subject_body, :screen_name, :choice
  
  def initialize(subject)
    self.subject_type          = subject.class.name
    self.subject_body  = subject.body
    
    case subject_type
    when "Question"
      self.param       = subject.to_param
    when "Answer"
      self.param       = subject.question.to_param
      self.screen_name = subject.question.user.screen_name
      self.choice      = subject.choice_name
    end
  end
  
  def url
    @url ||= shorten(question_answers_url(param, :host => Settings.host))
  end
    
  def body(joined_values)
    truncate(subject_body, :length => trimmed_size(joined_values))
  end
  
  def to_s
    case subject_type
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
    
    def shorten(url)
      UrlShortener::Client.new(bitly_authorization).shorten(url).urls
    end

    def bitly_authorization
      UrlShortener::Authorize.new(Settings.bitly.login, Settings.bitly.api_key)
    end
    
end