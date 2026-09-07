class ProcessGithubEventJob < ApplicationJob
  queue_as :default

  MAILER_ALLOWLIST = %w[pull_request issue star].freeze

  def perform(event_attrs)
    event = Event.new(event_attrs)

    if event.save
      if MAILER_ALLOWLIST.include?(event.event_type)
        RepoActivityMailer.new_event(event).deliver_now
      end
    elsif event.errors[:github_delivery_id].any?
      Rails.logger.info "Duplicate delivery #{event_attrs[:github_delivery_id]}, ignoring"
    else
      Rails.logger.warn "Event save failed: #{event.errors.full_messages}"
    end
  rescue StandardError => e
    Rails.logger.error "ProcessGithubEventJob failed: #{e.message}"
  end
end