module EventsHelper
  
  def question_for_event(event)
    event.subject_type == "Question" ? event.subject : event.subject.question
  end
  
  def present_events(events)
    events.map { |e| EventPresenter.new(:event => e, :controller => controller) }
  end
  
  # Renders and event partial
  # - object: Question or Answer instance
  #
  def render_event(object, options={})
    html   = options.delete(:html) || {}
    user   = object.user
    locals = (options.delete(:locals) || {}).merge(:user => user, :html => html)
    
    render :partial => object, :locals => locals
  end
end