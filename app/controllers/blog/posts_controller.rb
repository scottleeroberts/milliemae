class Blog::PostsController < BlogController

  def index
    @posts = published_posts.list_for(params[:page], params[:tag])
    load_filter_tag
  end

  def show
    @post = published_posts.friendly.find(params[:id])
  end

  private
  def load_filter_tag
    @filter_tag = params[:tag]
  end

  def published_posts
    Post.published
  end
end
