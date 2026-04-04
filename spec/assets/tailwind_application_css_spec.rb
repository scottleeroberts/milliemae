require "rails_helper"

RSpec.describe "Tailwind application CSS" do
  let(:css) { File.read(Rails.root.join("app/assets/tailwind/application.css")) }

  it "disables hotspot pulse animation when reduced motion is preferred" do
    expect(css).to include("@media (prefers-reduced-motion: reduce)")
    expect(css).to include(".animate-hotspot-pulse")
    expect(css).to include("animation: none;")
  end

  it "disables flash transitions when reduced motion is preferred" do
    expect(css).to include('[data-controller~="flash"]')
    expect(css).to include("transition: none;")
  end
end
