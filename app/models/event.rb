class Event < ApplicationRecord
  enum :event_type, { push: 0, pull_request: 1, issue: 2, star: 3, fork: 4 }
  enum :action, { opened: 0, closed: 1 }

  validates :github_delivery_id, uniqueness: true
end