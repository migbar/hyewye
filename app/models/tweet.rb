class Tweet
  include ActionController::UrlWriter
  include ActionView::Helpers::TextHelper
  
  HOST = "hyewye.com"
  ALLOWED_SIZE = 140
  HASHTAG = "#hyewye"
  
  attr_reader :subject
  
  def initialize(subject)
    @subject = subject
  end
  
  def url
    case subject
    when Question then question_answers_url(subject, :host => HOST)
    when Answer   then question_answers_url(subject.question, :host => HOST)
    end
  end
  
  def to_s
    max_size = ALLOWED_SIZE - (HASHTAG.size + 1 + url.size + 1)
    "#{HASHTAG} #{truncate(subject.body, :length => max_size)} #{url}"
  end
end