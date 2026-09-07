class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:github]

  EVENT_TYPE_MAP = {
    "push" => "push",
    "pull_request" => "pull_request",
    "issues" => "issue",
    "star" => "star",
    "fork" => "fork"
  }.freeze

  ACTION_MAP = {
    "opened" => "opened",
    "closed" => "closed"
  }.freeze

  def github
    raw_body = request.raw_post

    unless valid_signature?(raw_body)
      head :unauthorized and return
    end

    github_event = request.headers["X-GitHub-Event"]
    delivery_id  = request.headers["X-GitHub-Delivery"]
    payload      = JSON.parse(raw_body)

    event_type = EVENT_TYPE_MAP[github_event]
    unless event_type
      head :ok and return
    end

    event_attrs = {
      repo_full_name: payload.dig("repository", "full_name"),
      github_delivery_id: delivery_id,
      event_type: event_type,
      action: ACTION_MAP[payload["action"]],
      actor: payload.dig("sender", "login"),
      payload: payload,
      occurred_at: Time.current
    }

    ProcessGithubEventJob.perform_later(event_attrs)
    head :ok
  rescue JSON::ParserError
    head :bad_request
  end

  private

  def valid_signature?(raw_body)
    signature_header = request.headers["X-Hub-Signature-256"]
    return false if signature_header.blank?

    secret = Rails.application.credentials.github_webhook_secret
    expected_signature = "sha256=" + OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha256"), secret, raw_body
    )

    ActiveSupport::SecurityUtils.secure_compare(expected_signature, signature_header)
  end
end