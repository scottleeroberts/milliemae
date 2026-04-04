import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "xInput", "yInput", "annotationForm"]
  static classes = ["hidden", "annotating"]
  static values = { annotating: Boolean }

  connect() {
    this.annotatingValue = false
  }

  startAnnotating() {
    this.annotatingValue = true
  }

  placeHotspot(event) {
    if (!this.annotatingValue) return

    const rect = this.imageTarget.getBoundingClientRect()
    const x = Math.max(0, Math.min(1, (event.clientX - rect.left) / rect.width))
    const y = Math.max(0, Math.min(1, (event.clientY - rect.top) / rect.height))
    const offsetX = event.clientX - rect.left
    const offsetY = event.clientY - rect.top

    this.xInputTarget.value = x.toFixed(4)
    this.yInputTarget.value = y.toFixed(4)
    this.showAnnotationFormAt(offsetX, offsetY)
    this.annotatingValue = false
  }

  cancelAnnotating() {
    this.annotatingValue = false
    this.hideAnnotationForm()
  }

  hideAnnotationForm() {
    this.annotationFormTarget.classList.add(this.hiddenClass)
    this.annotationFormTarget.style.left = ""
    this.annotationFormTarget.style.top = ""
    if (this.hasXInputTarget) this.xInputTarget.value = ""
    if (this.hasYInputTarget) this.yInputTarget.value = ""
  }

  annotatingValueChanged() {
    this.imageTarget.classList.toggle(this.annotatingClass, this.annotatingValue)
  }

  showAnnotationFormAt(x, y) {
    this.annotationFormTarget.style.left = `${x}px`
    this.annotationFormTarget.style.top = `${y}px`
    this.annotationFormTarget.classList.remove(this.hiddenClass)
  }
}
