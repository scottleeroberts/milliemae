class Designers::PostsController < DesignerController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  def index
    @posts = current_designer.posts.order(:created_at)
  end

  def publish
    @post.publish
    redirect_to designers_posts_url
  end

  def unpublish
    @post.unpublish
    redirect_to designers_posts_url
  end

  def show
  end

  def new
    @post = current_designer.posts.new
  end

  def edit
  end

  def create
    @post = current_designer.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to designers_post_path(@post), notice: 'Post was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { render :edit, notice: 'Post was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to designers_posts_url, notice: 'Post was successfully destroyed.' }
    end
  end

  private

  def set_post
    @post = current_designer.posts.friendly.find(params[:id])
  end

  def post_params
    params
      .require(:post)
      .permit(:title, :body, :description, :tag_list, :flatlay_image, :showcase_image,
              :pattern_name, :pattern_url, :pattern_description, :inspiration_description,
              :fabric_description)
  end
end
