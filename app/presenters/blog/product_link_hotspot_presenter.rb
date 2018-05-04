class Blog::ProductLinkHotspotPresenter < Presenter
  presents :product_link

  def top
    return 0 unless product_link.y1
    (y1.to_f / image_height) * 100
  end

  def left
    return 0 unless product_link.x1
    (x1.to_f / image_width) * 100
  end

  def width
    ( (x2.to_f - x1.to_f) / image_width ) * 100
  end

  def height
    ( (y2.to_f - y1.to_f) / image_height ) * 100
  end

  private

  def image_height
    STANDARD_IMAGE_HEIGHT
  end

  def image_width
    STANDARD_IMAGE_WIDTH
  end
end

