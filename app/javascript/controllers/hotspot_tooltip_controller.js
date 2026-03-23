import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooltip", "tooltipLabel", "tooltipLink"]

  connect() {
    this.hideOnOutsideClick = this.hide.bind(this)
    this.hideOnEscape = (e) => { if (e.key === "Escape") this.hide() }
  }

  show(event) {
    event.preventDefault()
    event.stopPropagation()

    const dot = event.currentTarget
    const label = dot.dataset.label
    const url = dot.dataset.url

    this.tooltipLabelTarget.textContent = label
    this.tooltipLinkTarget.href = url

    // Position tooltip near the dot
    const container = this.element
    const containerRect = container.getBoundingClientRect()
    const dotRect = dot.getBoundingClientRect()

    let left = dotRect.left - containerRect.left + dotRect.width / 2
    let top = dotRect.top - containerRect.top + dotRect.height + 8

    // Show tooltip so we can measure it
    const tooltip = this.tooltipTarget
    tooltip.classList.remove("hidden")

    // Adjust if overflowing right
    const tooltipRect = tooltip.getBoundingClientRect()
    if (left + tooltipRect.width > containerRect.width) {
      left = containerRect.width - tooltipRect.width - 8
    }
    // Adjust if overflowing left
    if (left < 8) left = 8

    // If tooltip would overflow bottom, show above the dot
    if (top + tooltipRect.height > containerRect.height) {
      top = dotRect.top - containerRect.top - tooltipRect.height - 8
    }

    tooltip.style.left = `${left}px`
    tooltip.style.top = `${top}px`

    // Bind dismiss listeners (next tick so this click doesn't trigger it)
    requestAnimationFrame(() => {
      document.addEventListener("click", this.hideOnOutsideClick)
      document.addEventListener("keydown", this.hideOnEscape)
    })
  }

  hide() {
    this.tooltipTarget.classList.add("hidden")
    document.removeEventListener("click", this.hideOnOutsideClick)
    document.removeEventListener("keydown", this.hideOnEscape)
  }

  disconnect() {
    document.removeEventListener("click", this.hideOnOutsideClick)
    document.removeEventListener("keydown", this.hideOnEscape)
  }
}
