CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    aws_access_key_id:     ENV['S3_ACCESS_KEY'] || 'na',                        # required
    aws_secret_access_key: ENV['S3_SECRET_KEY'] || 'na',                        # required
    provider:              'AWS',                        # required
  }
  config.storage = :fog
  config.fog_directory  = ENV['S3_BUCKET'] || 'na'                                  # required
  config.fog_public     = false                                                 # optional, defaults to true
end
