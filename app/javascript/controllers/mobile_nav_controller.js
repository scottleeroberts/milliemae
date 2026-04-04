import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "overlay", "trigger", "closeButton"]

  connect() {
    this.boundEscape = this.onEscape.bind(this)
    this.applyClosedState()
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    this.returnFocusTo = document.activeElement
    this.menuTarget.classList.remove("hidden")
    this.overlayTarget.classList.remove("hidden")
    this.menuTarget.setAttribute("aria-hidden", "false")
    this.overlayTarget.setAttribute("aria-hidden", "false")
    this.triggerTarget.setAttribute("aria-expanded", "true")
    document.body.style.overflow = "hidden"
    document.addEventListener("keydown", this.boundEscape)
    this.closeButtonTarget.focus()
  }

  close() {
    const returnFocusTo = this.returnFocusTo
    this.applyClosedState()
    if (returnFocusTo?.focus) returnFocusTo.focus()
  }

  closeOnLink() {
    this.close()
  }

  disconnect() {
    this.applyClosedState()
  }

  get isOpen() {
    return !this.menuTarget.classList.contains("hidden")
  }

  applyClosedState() {
    this.menuTarget.classList.add("hidden")
    this.overlayTarget.classList.add("hidden")
    this.menuTarget.setAttribute("aria-hidden", "true")
    this.overlayTarget.setAttribute("aria-hidden", "true")
    if (this.hasTriggerTarget) this.triggerTarget.setAttribute("aria-expanded", "false")
    document.body.style.overflow = ""
    document.removeEventListener("keydown", this.boundEscape)
    this.returnFocusTo = null
  }

  onEscape(event) {
    if (event.key === "Escape") this.close()
  }
}
