class Blog::PostsController < BlogController

  def index
    t = params[:tag]
    @posts = if t.present?
               Post.most_recent.published.tagged_with(t).paginate(:page => params[:page], per_page: 3)
             else
               Post.most_recent.published.paginate(:page => params[:page], per_page: 3)
             end
  end

  def show
    @post = Post.friendly.find(params[:id])
  end
end
