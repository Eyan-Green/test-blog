import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "alert" ]

  hide(event) {
    event.preventDefault();
    this.alertTarget.classList.add("opacity-0");
    setTimeout(() => {
      this.alertTarget.classList.add("hidden");
    }, 500);
  }
}
