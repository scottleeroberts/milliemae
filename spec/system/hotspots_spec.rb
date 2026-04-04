require "rails_helper"

RSpec.describe "Hotspot tooltips", type: :system do
  let(:creator) { create(:user, :creator) }
  let(:project) { create(:project, :published, user: creator) }
  let!(:image)  { create(:project_image, project: project, position: 0) }
  let!(:link1)  { create(:product_link, project_image: image, label: "Linen Fabric", url: "https://example.com/linen", x: 0.3, y: 0.3) }
  let!(:link2)  { create(:product_link, project_image: image, label: "Cotton Thread", url: "https://example.com/thread", x: 0.7, y: 0.5) }

  before { visit project_path(project) }

  def tooltip
    find("[data-hotspot-tooltip-target='tooltip']", visible: :all)
  end

  def first_pin
    find("[aria-label^='Product 1:']")
  end

  describe "on desktop" do
    it "shows the tooltip when a pin is clicked" do
      first_pin.click
      expect(tooltip).not_to match_css(".hidden")
      expect(first_pin["aria-expanded"]).to eq("true")
      expect(tooltip["aria-hidden"]).to eq("false")
      within(tooltip) do
        expect(page).to have_text("Linen Fabric")
      end
    end

    it "includes a Shop link pointing to the product URL" do
      first_pin.click
      within(tooltip) do
        expect(page).to have_link("Shop →", href: "https://example.com/linen")
      end
    end

    it "toggles the tooltip closed when the same pin is clicked again" do
      pin = first_pin
      pin.click
      expect(tooltip).not_to match_css(".hidden")
      pin.click
      expect(tooltip).to match_css(".hidden")
      expect(pin["aria-expanded"]).to eq("false")
      expect(tooltip["aria-hidden"]).to eq("true")
    end

    it "hides the tooltip when clicking outside the image" do
      first_pin.click
      expect(tooltip).not_to match_css(".hidden")
      find("h1").click
      expect(tooltip).to match_css(".hidden")
    end

    it "switches to the second pin's tooltip when the first is open" do
      first_pin.click
      within(tooltip) do
        expect(page).to have_text("Linen Fabric")
      end
      find("[aria-label^='Product 2:']").click
      within(tooltip) do
        expect(page).to have_text("Cotton Thread")
        expect(page).not_to have_text("Linen Fabric")
      end
    end

    it "hides the tooltip on Escape" do
      first_pin.click
      expect(tooltip).not_to match_css(".hidden")
      find("body").send_keys(:escape)
      expect(tooltip).to match_css(".hidden")
      expect(first_pin["aria-expanded"]).to eq("false")
    end

    it "returns focus to the active pin on Escape" do
      first_pin.click

      find("body").send_keys(:escape)

      expect(page.evaluate_script("document.activeElement.getAttribute('aria-label')")).to start_with("Product 1:")
    end
  end

  describe "on mobile", mobile: true do
    it "shows the tooltip when a pin is tapped" do
      first_pin.click
      expect(tooltip).not_to match_css(".hidden")
      within(tooltip) do
        expect(page).to have_text("Linen Fabric")
      end
    end

    it "toggles the tooltip closed when the same pin is tapped again" do
      pin = first_pin
      pin.click
      expect(tooltip).not_to match_css(".hidden")
      pin.click
      expect(tooltip).to match_css(".hidden")
    end

    it "switches to a different pin's tooltip" do
      first_pin.click
      within(tooltip) do
        expect(page).to have_text("Linen Fabric")
      end
      # On mobile, the tooltip may overlap pin 2 — dismiss first
      first_pin.click
      expect(tooltip).to match_css(".hidden")
      find("[aria-label^='Product 2:']").click
      within(tooltip) do
        expect(page).to have_text("Cotton Thread")
      end
    end
  end
end
