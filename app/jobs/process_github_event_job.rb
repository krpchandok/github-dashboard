class ProcessGithubEventJob < ApplicationJob
  queue_as :default

  MAILER_ALLOWLIST = %w[pull_request issue star].freeze

  def perform(event_attrs, repo_data = nil)
    if repo_data
      Repository.find_or_create_by(full_name: repo_data["full_name"]) do |repo|
        repo.description = repo_data["description"]
        repo.html_url = repo_data["html_url"]
        repo.language = repo_data["language"]
        repo.stargazers_count = repo_data["stargazers_count"]
        repo.default_branch = repo_data["default_branch"]
        repo.avatar_url = repo_data.dig("owner", "avatar_url")
      end
    end

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