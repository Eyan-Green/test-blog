import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "alert", "notifications" ]

  hide(event) {
    event.preventDefault()
    this.alertTarget.classList.add("hidden")   
  }

  toggle(event) {
    event.preventDefault()
    this.notificationsTarget.classList.toggle("hidden") 
  }
}
