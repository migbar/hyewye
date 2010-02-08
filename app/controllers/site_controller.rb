class SiteController < ApplicationController
  def index
    @events = Event.latest(Settings.home_events_limit)
  end
end