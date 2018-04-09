module StandardUploader
  extend ActiveSupport::Concern

  included do
    if Rails.env.production?
      storage :fog
    else
      storage :file
    end

    process resize_to_fit: [1200, 800]

    version :mini do
      process resize_to_fit: [700, 400]
    end

    version :thumb do
      process resize_to_fit: [200, 200]
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
end
