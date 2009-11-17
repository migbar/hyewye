class EventPresenter < ActivePresenter::Base
  include ActionView::Helpers::RecordIdentificationHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  
  presents :event
  attr_accessor :controller

  delegate :subject, :user, :to => :event
  delegate :login, :to => :user
  delegate :body, :to => :subject
  
  def dom_id
    super(subject)
  end
  
  def dom_class
    super(subject)
  end
  
  def when_answer
    yield if answer?
  end
  
  def link_to_user
    link_to h(login), user_path(user)
  end
  
  def link_to_question(label)
    link_to label, question_answers_path(question)
  end
  
  def question
    event.subject_type == "Question" ? event.subject : event.subject.question
  end
  
  def choice
    subject.choice_name if answer?
  end
  
  def answer?
    Answer === subject
  end
  
  def method_missing(sym, *args, &block)
    if sym.to_s =~ /_(path|url)$/
      # Delegate all named routes to the controller
      controller.send(sym, *args)
    else
      super
    end
  end
end