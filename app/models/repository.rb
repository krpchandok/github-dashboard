class Repository < ApplicationRecord
  has_many :events, foreign_key: :repo_full_name, primary_key: :full_name
  validates :full_name, uniqueness: true

  def self.sync_from_github!(github_username)
    token = Rails.application.credentials.github_personal_access_token
    webhook_url = "https://github-dashboard-ejgz.onrender.com/webhooks/github"

    conn_headers = {
      "Authorization" => "Bearer #{token}",
      "Accept" => "application/vnd.github+json"
    }

    repos_response = HTTParty.get("https://api.github.com/users/#{github_username}/repos", headers: conn_headers)
    repos = repos_response.parsed_response

    repos.each do |repo_data|
      hooks_response = HTTParty.get(
        "https://api.github.com/repos/#{repo_data['full_name']}/hooks",
        headers: conn_headers
      )
      hooks = hooks_response.parsed_response

      next unless hooks.is_a?(Array)

      has_our_webhook = hooks.any? { |hook| hook.dig("config", "url") == webhook_url }
      next unless has_our_webhook

      find_or_create_by(full_name: repo_data["full_name"]) do |repo|
        repo.description = repo_data["description"]
        repo.html_url = repo_data["html_url"]
        repo.language = repo_data["language"]
        repo.stargazers_count = repo_data["stargazers_count"]
        repo.default_branch = repo_data["default_branch"]
        repo.avatar_url = repo_data.dig("owner", "avatar_url")
      end
    end
  end
end