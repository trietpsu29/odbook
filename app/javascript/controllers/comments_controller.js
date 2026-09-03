import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["section", "icon"];

  toggle() {
    this.sectionTarget.classList.toggle("hidden");
    const currentSrc = this.iconTarget.src;
    const outlineSrc = this.iconTarget.dataset.outlineSrc;
    const fillSrc = this.iconTarget.dataset.fillSrc;

    if (currentSrc.includes("comment-fill")) {
      this.iconTarget.src = outlineSrc;
    } else {
      this.iconTarget.src = fillSrc;
    }
  }
}
