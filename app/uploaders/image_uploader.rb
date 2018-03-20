class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  process resize_to_fit: [1200, 800]

  version :mini do
    process resize_to_fill: [200, 200]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "image.#{file.extension}" if original_filename
  end
end
