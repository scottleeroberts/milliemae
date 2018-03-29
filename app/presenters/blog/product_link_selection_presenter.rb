class Blog::ProductLinkSelectionPresenter < Presenter
  presents :product_link

  def top
    return 0 unless product_link.y1
    (y1.to_f / image_height) * 100
  end

  def bottom
    return 0 unless product_link.y2
    (y2.to_f / image_height) * 100
  end

  def left
    return 0 unless product_link.x1
    (x1.to_f / image_width) * 100
  end

  def right
    return 0 unless product_link.x2
    (x2.to_f / image_width) * 100
  end

  private

  def image_height
    post.flatlay_height.to_f
  end

  def image_width
    post.flatlay_width.to_f
  end
end

