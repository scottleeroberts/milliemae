module RequestHelpers
  def turbo_stream_headers
    { "Accept" => "text/vnd.turbo-stream.html, text/html" }
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request

  # Rails HostAuthorization blocks the default test host (www.example.com).
  # Use an IP address, which the app allows via 0.0.0.0/0.
  config.before(:each, type: :request) do
    host!("127.0.0.1")
  end
end
