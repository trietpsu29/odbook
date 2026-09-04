import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["count"];

  show(event) {
    const count = event.target.files.length;

    this.countTarget.textContent = count > 0 ? `${count} images selected` : "";
  }
}
