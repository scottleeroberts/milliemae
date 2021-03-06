class Designers::ProductLinksController < DesignerController

  def index
    @product_links = ProductLink.all
  end

  def new
    load_post
  end

  def edit
    load_post
    @product_link = ProductLink.find(params.fetch(:id))
  end

  def create
    load_post
    @product_link = ProductLink.new(product_link_params.merge(post_id: @post.id))

    if @product_link.save
      flash[:success] = 'Product Link Successfully added'
      render :create
    else
      flash[:danger] = @product_link.pretty_errors
      render :new
    end
  end

  def update
    load_post
    @product_link = ProductLink.find(params.fetch(:id))

    if @product_link.update(product_link_params)
      flash[:success] = 'Product Link Successfully added'
    else
      flash[:danger] = @product_link.pretty_errors
    end
    render :update
  end

  def destroy
    @product_link = ProductLink.find(params.fetch(:id))
    @product_link.destroy!
  end

  private

  def load_post
    @post = Post.friendly.find(params[:post_id])
  end

  def product_link_params
    params.require(:product_link).permit(:url, :description, :x1, :y1, :x2, :y2, :width, :height)
  end
end

