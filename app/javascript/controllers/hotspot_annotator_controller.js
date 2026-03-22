import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "xInput", "yInput", "annotationForm"]

  connect() {
    this.annotating = false
  }

  startAnnotating() {
    this.annotating = true
    this.imageTarget.classList.add("cursor-crosshair")
  }

  placeHotspot(event) {
    if (!this.annotating) return

    const rect = this.imageTarget.getBoundingClientRect()
    const x = Math.max(0, Math.min(1, (event.clientX - rect.left) / rect.width))
    const y = Math.max(0, Math.min(1, (event.clientY - rect.top) / rect.height))

    this.xInputTarget.value = x.toFixed(4)
    this.yInputTarget.value = y.toFixed(4)

    const offsetX = event.clientX - rect.left
    const offsetY = event.clientY - rect.top
    this.annotationFormTarget.style.left = `${offsetX}px`
    this.annotationFormTarget.style.top = `${offsetY}px`
    this.annotationFormTarget.classList.remove("hidden")

    this.annotating = false
    this.imageTarget.classList.remove("cursor-crosshair")
  }

  cancelAnnotating() {
    this.annotating = false
    this.imageTarget.classList.remove("cursor-crosshair")
    this.annotationFormTarget.classList.add("hidden")
  }

  hideAnnotationForm() {
    this.annotationFormTarget.classList.add("hidden")
    this.annotationFormTarget.style.left = ""
    this.annotationFormTarget.style.top = ""
    if (this.hasXInputTarget) this.xInputTarget.value = ""
    if (this.hasYInputTarget) this.yInputTarget.value = ""
  }
}
