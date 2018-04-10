module StandardUploader
  extend ActiveSupport::Concern

  included do
    if Rails.env.production?
      storage :fog
    else
      storage :file
    end

    process resize_to_fit: [1200, 800]
    process :optimize

    version :mini do
      process resize_to_fit: [700, 400]
      process :optimize
    end

    version :thumb do
      process resize_to_fit: [200, 200]
      process :optimize
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def optimize
    manipulate! do |img|
      return img unless img.mime_type.match /image\/jpeg/
      img.strip
      img.combine_options do |c|
        c.quality "80"
        c.interlace "plane"
      end
      img
    end
  end
end
