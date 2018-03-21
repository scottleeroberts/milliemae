class ShowcaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include StandardUploader


  def filename
    "showcase.#{file.extension}" if original_filename
  end
end
