module EventsHelper
  
  def question_for_event(event)
    event.target_type == "Question" ? event.target : event.target.question
  end
  
  def present_events(events)
    events.map { |e| EventPresenter.new(:event => e, :controller => controller)}
  end
end