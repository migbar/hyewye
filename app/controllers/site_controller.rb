class SiteController < ApplicationController
  def index
    @events = Event.latest(Settings.home_events_limit)
    @sidebar_question = Question.for_sidebar
    # @random_question = (@events.collect {|each_event| question_for_event(each_event)}).detect{ |each_question| each_question.answers.size > 0}
  end
end