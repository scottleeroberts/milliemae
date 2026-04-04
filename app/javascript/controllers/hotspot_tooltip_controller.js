import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooltip", "tooltipLabel", "tooltipLink"]

  connect() {
    this._activePin = null
    this.hideOnOutsideClick = this.hide.bind(this)
    this.hideOnEscape = (e) => { if (e.key === "Escape") this.hide() }
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    const dot = event.currentTarget
    const isVisible = !this.tooltipTarget.classList.contains("hidden")

    if (isVisible && this._activePin === dot) {
      this.hide()
      return
    }

    this._activePin = dot
    this._reveal(dot)
  }

  hide() {
    this.tooltipTarget.classList.add("hidden")
    this._activePin = null
    document.removeEventListener("click", this.hideOnOutsideClick)
    document.removeEventListener("keydown", this.hideOnEscape)
  }

  disconnect() {
    document.removeEventListener("click", this.hideOnOutsideClick)
    document.removeEventListener("keydown", this.hideOnEscape)
  }

  // — private —

  _reveal(dot) {
    this.tooltipLabelTarget.textContent = dot.dataset.label
    this.tooltipLinkTarget.href = dot.dataset.url

    const container = this.element
    const containerRect = container.getBoundingClientRect()
    const dotRect = dot.getBoundingClientRect()

    let left = dotRect.left - containerRect.left + dotRect.width / 2
    let top = dotRect.top - containerRect.top + dotRect.height + 8

    const tooltip = this.tooltipTarget
    tooltip.classList.remove("hidden")

    const tooltipRect = tooltip.getBoundingClientRect()

    if (left + tooltipRect.width > containerRect.width) {
      left = containerRect.width - tooltipRect.width - 8
    }
    if (left < 8) left = 8

    if (top + tooltipRect.height > containerRect.height) {
      top = dotRect.top - containerRect.top - tooltipRect.height - 8
    }

    tooltip.style.left = `${left}px`
    tooltip.style.top = `${top}px`

    // Bind dismiss listeners in the next frame so this click doesn't immediately
    // trigger hideOnOutsideClick. document.addEventListener deduplicates same-reference
    // listeners, so calling this on each _reveal is safe.
    requestAnimationFrame(() => {
      document.addEventListener("click", this.hideOnOutsideClick)
      document.addEventListener("keydown", this.hideOnEscape)
    })
  }
}
