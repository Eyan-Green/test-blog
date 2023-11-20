import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "alert", "notifications" ]

  hide(event) {
    event.preventDefault()
    this.alertTarget.classList.add("hidden")
  }

  toggle(event) {
    event.preventDefault();
    const notificationsElement = this.notificationsTarget;

    // If the element is already visible, hide it
    if (notificationsElement.classList.contains("h-0")) {
      notificationsElement.classList.remove("h-0");
      notificationsElement.classList.add("h-96");
    } else {
      notificationsElement.classList.remove("h-96");
      notificationsElement.classList.add("h-0");
    }
  }
}
