import { Controller } from "@hotwired/stimulus"
import PhotoSwipeLightbox from "photoswipe/lightbox"

export default class extends Controller {
  connect() {
    this.lightbox = new PhotoSwipeLightbox({
      gallery: this.element,
      children: "a[data-pswp-width]",
      paddingFn: (viewportSize) => {
        return {
          top: viewportSize.y * 0.05,
          right: viewportSize.x * 0.05,
          bottom: viewportSize.y * 0.05,
          left: viewportSize.x * 0.05,
        }
      },
      pswpModule: () => import("photoswipe"),
    })

    this.lightbox.init()
  }

  disconnect() {
    this.lightbox?.destroy()
  }
}
