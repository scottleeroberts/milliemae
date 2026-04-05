import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { activeIndex: { type: Number, default: 0 } }

  connect() {
    this.showTab(this.activeIndexValue)
  }

  select(event) {
    const index = parseInt(event.currentTarget.dataset.index, 10)
    this.showTab(index)
  }

  showTab(index) {
    this.tabTargets.forEach((tab, i) => {
      if (i === index) {
        tab.classList.add("bg-white", "text-pink-600", "border-b-2", "border-pink-600", "font-medium")
        tab.classList.remove("text-gray-500", "hover:text-gray-700")
      } else {
        tab.classList.remove("bg-white", "text-pink-600", "border-b-2", "border-pink-600", "font-medium")
        tab.classList.add("text-gray-500", "hover:text-gray-700")
      }
    })

    this.panelTargets.forEach((panel, i) => {
      if (i === index) {
        panel.classList.remove("hidden")
      } else {
        panel.classList.add("hidden")
      }
    })

    this.activeIndexValue = index
  }
}
