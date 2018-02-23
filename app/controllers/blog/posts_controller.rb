class Blog::PostsController < BlogController

  def index
    @posts = Post.most_recent
  end

  def show
    @post = Post.friendly.find(params[:id])
  end
end
