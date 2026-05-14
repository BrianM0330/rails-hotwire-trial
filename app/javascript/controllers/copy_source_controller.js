import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]
  static values = { url: String }

  async copy() {
    try {
      await navigator.clipboard.writeText(this.urlValue)
      this.showToast("Copied")
    } catch (_error) {
      this.showToast("Copy failed")
    }
  }

  showToast(message) {
    clearTimeout(this.timeout)
    this.toastTarget.textContent = message
    this.toastTarget.classList.remove("hidden")

    this.timeout = setTimeout(() => {
      this.toastTarget.classList.add("hidden")
    }, 1400)
  }
}
