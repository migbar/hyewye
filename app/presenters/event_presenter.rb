class EventPresenter < ActivePresenter::Base
  include ActionView::Helpers::RecordIdentificationHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  
  presents :event
  attr_accessor :controller

  delegate :target, :user, :to => :event
  delegate :login, :to => :user
  delegate :body, :to => :target
  
  def dom_id
    super(target)
  end
  
  def dom_class
    super(target)
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
    event.target_type == "Question" ? event.target : event.target.question
  end
  
  def choice
    target.choice_name if answer?
  end
  
  def answer?
    Answer === target
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