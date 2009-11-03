class SiteController < ApplicationController
  def index
    @events = Event.latest
  end
end