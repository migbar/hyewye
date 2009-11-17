module EventsHelper
  
  def question_for_event(event)
    event.subject_type == "Question" ? event.subject : event.subject.question
  end
  
  def present_events(events)
    events.map { |e| EventPresenter.new(:event => e, :controller => controller) }
  end
end