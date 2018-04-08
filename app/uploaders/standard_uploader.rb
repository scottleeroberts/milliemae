module StandardUploader
  extend ActiveSupport::Concern
  include CarrierWave::ImageOptimizer

  included do
    if Rails.env.production?
      storage :fog
    else
      storage :file
    end

    process resize_to_fit: [1000, 667]
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
end
