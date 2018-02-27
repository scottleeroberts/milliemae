class Blog::PostsController < BlogController

  def index
    @posts = published_posts.list_for(params[:page], params[:tag])
  end

  def show
    @post = published_posts.friendly.find(params[:id])
  end

  private

  def published_posts
    Post.published
  end
end
