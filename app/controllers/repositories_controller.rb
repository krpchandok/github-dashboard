class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.order(:full_name)
  end

  def show
    @repository = Repository.find(params[:id])
    @events = @repository.events.order(occurred_at: :desc).limit(30)
    @contributors = @repository.events.group(:actor).order(Arel.sql("count_all DESC")).count
    @tab = params[:tab].presence || "activity"
  end

  def update
    @repository = Repository.find(params[:id])
    @repository.update(about_params)
    redirect_to repository_path(@repository, tab: "about")
  end

  private

  def about_params
    params.require(:repository).permit(:about)
  end
end