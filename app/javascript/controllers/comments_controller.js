import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["section"];

  toggle() {
    this.sectionTarget.classList.toggle("hidden");
  }
}
