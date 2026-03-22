require "capybara/rspec"
require "socket"

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch("SELENIUM_URL", "http://chrome:4444/wd/hub"),
    options: options
  )
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :remote_chrome

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :remote_chrome
    Capybara.server_host = "0.0.0.0"
    Capybara.server_port = 3001
    ip = IPSocket.getaddress(Socket.gethostname)
    Capybara.app_host = "http://#{ip}:3001"
  end
end
