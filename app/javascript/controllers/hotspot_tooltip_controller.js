import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooltip", "tooltipLabel", "tooltipLink", "pin"]
  static classes = ["hidden"]
  static values = { open: Boolean }

  connect() {
    this.activePin = null
    this.hideOnOutsideClick = this.hideOnOutsideClick.bind(this)
    this.hideOnEscape = this.hideOnEscape.bind(this)
    this.openValue = false
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    const pin = event.currentTarget

    if (this.openValue && this.activePin === pin) {
      this.hide()
      return
    }

    this.activePin = pin
    this.reveal(pin)
  }

  hide() {
    this.activePin = null
    this.openValue = false
    document.removeEventListener("click", this.hideOnOutsideClick)
    document.removeEventListener("keydown", this.hideOnEscape)
  }

  disconnect() {
    this.hide()
  }

  openValueChanged() {
    const isOpen = this.openValue
    this.tooltipTarget.classList.toggle(this.hiddenClass, !isOpen)
    this.tooltipTarget.setAttribute("aria-hidden", isOpen ? "false" : "true")
    this.pinTargets.forEach((pin) => {
      pin.setAttribute("aria-expanded", this.activePin === pin && isOpen ? "true" : "false")
    })
  }

  hideOnOutsideClick(event) {
    if (this.element.contains(event.target)) return
    this.hide()
  }

  hideOnEscape(event) {
    if (event.key !== "Escape") return

    const activePin = this.activePin
    this.hide()
    if (activePin?.focus) activePin.focus()
  }

  reveal(pin) {
    this.tooltipLabelTarget.textContent = pin.dataset.label
    this.tooltipLinkTarget.href = pin.dataset.url

    const containerRect = this.element.getBoundingClientRect()
    const pinRect = pin.getBoundingClientRect()

    let left = pinRect.left - containerRect.left + pinRect.width / 2
    let top = pinRect.top - containerRect.top + pinRect.height + 8

    this.openValue = true

    const tooltipRect = this.tooltipTarget.getBoundingClientRect()

    if (left + tooltipRect.width > containerRect.width) {
      left = containerRect.width - tooltipRect.width - 8
    }
    if (left < 8) left = 8

    if (top + tooltipRect.height > containerRect.height) {
      top = pinRect.top - containerRect.top - tooltipRect.height - 8
    }

    this.tooltipTarget.style.left = `${left}px`
    this.tooltipTarget.style.top = `${top}px`

    requestAnimationFrame(() => {
      document.addEventListener("click", this.hideOnOutsideClick)
      document.addEventListener("keydown", this.hideOnEscape)
    })
  }
}
