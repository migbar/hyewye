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
  
  def linkify(text_blob)
    auto_link(h(text_blob.to_s), :html => {:target => "_blank", :rel => "nofollow" }) do |text|
      truncate(text.gsub(/^https?:\/\//, ''), :length => 40)
    end
  end
end