class FlatlayUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include StandardUploader

  process :store_dimensions

  def filename
    "flatlay.#{file.extension}" if original_filename
  end

  def store_dimensions
    if file && model
      model.flatlay_width, model.flatlay_height = ::MiniMagick::Image.open(file.file)[:dimensions]
    end
  end
end
