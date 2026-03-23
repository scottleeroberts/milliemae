import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "overlay"]

  toggle() {
    const isHidden = this.menuTarget.classList.contains("hidden")
    if (isHidden) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.overlayTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
    this._boundEscape = this._onEscape.bind(this)
    document.addEventListener("keydown", this._boundEscape)
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.overlayTarget.classList.add("hidden")
    document.body.style.overflow = ""
    if (this._boundEscape) {
      document.removeEventListener("keydown", this._boundEscape)
    }
  }

  closeOnLink(event) {
    // Close drawer when a nav link is clicked
    this.close()
  }

  _onEscape(event) {
    if (event.key === "Escape") this.close()
  }

  disconnect() {
    document.body.style.overflow = ""
    if (this._boundEscape) {
      document.removeEventListener("keydown", this._boundEscape)
    }
  }
}
