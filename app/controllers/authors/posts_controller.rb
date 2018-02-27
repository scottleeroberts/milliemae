class Authors::PostsController < AuthorController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  def index
    @posts = current_author.posts
  end

  def publish
    @post.publish
    redirect_to authors_posts_url
  end

  def unpublish
    @post.unpublish
    redirect_to authors_posts_url
  end

  def show
  end

  def new
    @post = current_author.posts.new
  end

  def edit
  end

  def create
    @post = current_author.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to authors_post_path(@post), notice: 'Post was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to authors_post_path(@post), notice: 'Post was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to authors_posts_url, notice: 'Post was successfully destroyed.' }
    end
  end

  private
  def set_post
    @post = current_author.posts.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :description, :banner_image_url, :tag_list)
  end
end
