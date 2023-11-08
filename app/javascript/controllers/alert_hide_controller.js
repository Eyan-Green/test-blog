import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "alert" ]

  hide(event) {
    event.preventDefault()
    this.alertTarget.classList.add("hidden")   
  }
}
