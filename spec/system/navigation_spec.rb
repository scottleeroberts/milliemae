require "rails_helper"

RSpec.describe "Navigation", type: :system, mobile: true do
  it "opens and closes the mobile navigation drawer with accessible state" do
    visit root_path

    trigger = find('button[aria-controls="mobile-navigation"]', visible: true)
    drawer = find("#mobile-navigation", visible: :all)

    expect(trigger["aria-expanded"]).to eq("false")
    expect(drawer["aria-hidden"]).to eq("true")

    trigger.click

    expect(trigger["aria-expanded"]).to eq("true")
    expect(drawer["aria-hidden"]).to eq("false")
    expect(page).to have_css("#mobile-navigation:not(.hidden)", visible: :all)
    expect(page.evaluate_script("document.activeElement.getAttribute('aria-label')")).to eq("Close menu")

    page.send_keys(:escape)

    expect(trigger["aria-expanded"]).to eq("false")
    expect(drawer["aria-hidden"]).to eq("true")
    expect(page).to have_css("#mobile-navigation.hidden", visible: :all)
    expect(page.evaluate_script("document.activeElement.getAttribute('aria-controls')")).to eq("mobile-navigation")
  end

  it "closes the mobile navigation drawer when a nav link is activated" do
    visit root_path

    find('button[aria-controls="mobile-navigation"]', visible: true).click
    within("#mobile-navigation") { click_link "About" }

    expect(page).to have_current_path(about_path)
    expect(find("#mobile-navigation", visible: :all)["aria-hidden"]).to eq("true")
  end
end
