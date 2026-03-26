module RequestHelpers
  def turbo_stream_headers
    { "Accept" => "text/vnd.turbo-stream.html, text/html" }
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
