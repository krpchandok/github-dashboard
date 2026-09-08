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
    if @repository.update(about_params)
      redirect_to repository_path(@repository, tab: "about")
    else
      @events = @repository.events.order(occurred_at: :desc).limit(30)
      @contributors = @repository.events.group(:actor).order(Arel.sql("count_all DESC")).count
      @tab = "about"
      flash.now[:alert] = @repository.errors.full_messages.join(", ")
      render :show
    end
  end

  def sync
    Repository.sync_from_github!("krpchandok")
    redirect_to root_path, notice: "Synced repos from GitHub"
  end

  private

  def about_params
    params.require(:repository).permit(:about)
  end
end