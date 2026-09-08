class DashboardController < ApplicationController
  def index
    @repositories = Repository.includes(:events).order(:full_name)
    @events = Event.order(occurred_at: :desc).limit(50)
    @total_events = Event.count
    @top_contributors = Event.group(:actor).order(Arel.sql("count_all DESC")).count.first(5)
    @event_type_counts = Event.group(:event_type).count
  end
end