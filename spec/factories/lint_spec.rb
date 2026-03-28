require "rails_helper"

RSpec.describe "FactoryBot factories", :factory_lint do
  it "lint all factories and traits" do
    FactoryBot.lint(traits: true)
  end
end
