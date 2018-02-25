class Blog::PostsController < BlogController

  def index
    @posts = Post.most_recent.published
  end

  def show
    @post = Post.friendly.find(params[:id])
  end
end
