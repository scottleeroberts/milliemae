import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => this.dismiss(), 5000)
  }

  close() {
    this.dismiss()
  }

  dismiss() {
    clearTimeout(this.timeout)
    this.element.classList.add("is-dismissing")
    setTimeout(() => this.element.remove(), 300)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
