import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"];

  toggle(event) {
    this.menuTarget.classList.toggle("hidden");
  }
}
