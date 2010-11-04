class SiteController < ApplicationController
  def index
    @events = Event.latest(Settings.home_events_limit)
    @sidebar_question = Question.for_sidebar
  end
end