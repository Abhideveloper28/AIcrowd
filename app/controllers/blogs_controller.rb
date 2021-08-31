class BlogsController < ApplicationController
  before_action :authenticate_participant!,
                except: [:show, :index]
  before_action :set_blog, only: :show
  before_action :set_vote, only: :show
  before_action :set_follow, only: [:show]

  def index
    @blogs = policy_scope(Blog)
      .order(seq: :asc, posted_at: :desc)
      .per_page_kaminari(params[:page])
      .per(100)
  end

  def show
    @blog.record_page_view unless params[:version] # don't record page views on history pages
    commontator_thread_show(@blog)
  end

  private

  def set_blog
    @blog = Blog.friendly.find(params[:id])
    # Randomly select 3 blogs
    @selected_blogs = Blog.where.not(id: @blog.id).order("RANDOM()").sample(3)
    authorize @blog
  end

  def set_vote
    @vote = @blog.votes.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def set_follow
    @follow = @blog.participant.follows.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def blog_params
    params.require(:blog).permit(:participant_id, :title, :body, :published, :vote_count, :view_count)
  end
end
