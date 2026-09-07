class RepoActivityMailer < ApplicationMailer
  def new_event(event)
    @event = event
    mail(
      to: ENV["REPO_OWNER_EMAIL"],
      subject: "New #{@event.event_type} on #{@event.repo_full_name}"
    )
  end
end