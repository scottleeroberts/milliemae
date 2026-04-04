require "spec_helper"
require "base64"
ENV["RAILS_ENV"] = "test"
require_relative "../config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

Rails.root.glob("spec/support/**/*.rb").sort_by(&:to_s).each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.filter_run_excluding factory_lint: true

  config.before(:suite) do
    connection = ActiveRecord::Base.connection
    connection.disable_referential_integrity do
      (connection.tables - %w[ar_internal_metadata schema_migrations]).each do |table|
        connection.execute("TRUNCATE TABLE #{connection.quote_table_name(table)} RESTART IDENTITY CASCADE")
      end
    end

    fixture_dir = Rails.root.join("spec/fixtures/files")
    FileUtils.mkdir_p(fixture_dir)
    png_path = fixture_dir.join("test_image.png")
    unless png_path.exist?
      # Minimal 1x1 white PNG
      png_bytes = Base64.decode64(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="
      )
      File.binwrite(png_path, png_bytes)
    end
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
end
