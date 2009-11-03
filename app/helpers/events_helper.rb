module EventsHelper
  def question_for_event(event)
    event.target_type == "Question" ? event.target : event.target.question
  end
  
end