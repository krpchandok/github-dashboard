class DashboardController < ApplicationController
  def index
    @events = Event.order(occurred_at: :desc).limit(50)

    @top_contributors = Event.group(:actor).order(Arel.sql("count_all DESC")).count.first(5)
    @event_type_counts = Event.group(:event_type).count
    @total_events = Event.count
  end
end