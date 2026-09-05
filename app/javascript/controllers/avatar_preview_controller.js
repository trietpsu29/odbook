import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["preview"];

  show(event) {
    const file = event.target.files[0];

    if (!file) return;

    this.previewTarget.src = URL.createObjectURL(file);
  }
}
