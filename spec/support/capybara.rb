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

Capybara.register_driver :mobile_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=390,844")

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch("SELENIUM_URL", "http://chrome:4444/wd/hub"),
    options: options
  )
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :remote_chrome
Capybara.server_host = "0.0.0.0"

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :remote_chrome
    ip = IPSocket.getaddress(Socket.gethostname)
    Capybara.app_host = "http://#{ip}:#{Capybara.server_port}"
  end
end
