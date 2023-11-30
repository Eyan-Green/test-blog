import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "notifications", "counter", "bell", "list", "expand" ]

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

  toggleOpacity() {
    const expandElement = this.expandTarget;

    // Check if the element is hidden
    if (expandElement.classList.contains("opacity-0")) {
      // If hidden, gradually increase opacity and height after a short delay
      setTimeout(() => {
        expandElement.classList.remove("opacity-0");
        expandElement.classList.add("opacity-100");    
      }, 50);
    } else {
      // If visible, decrease opacity and height before hiding after a short delay
      setTimeout(() => {
        expandElement.classList.remove("opacity-100");
        expandElement.classList.add("opacity-0");      
      }, 50);
    }
  }

  hamburger(event) {
    event.preventDefault();
    this.toggleOpacity();
    this.expandTarget.classList.toggle("hidden")
  }

  counterTargetConnected() {
    this.poll()
  }

  poll() {
    setInterval(() => {
      this.loadCounter();
    }, 5000);
  }

  async loadCounter() {
    const url = '/notifications';
    try {
      const response = await fetch(url);
      if (response.ok) {
        const data = await response.json()
        this.counterTarget.innerHTML = data.length
        if (data.length > 0) {
          this.counterTarget.classList.add('text-red-500')
          this.bellTarget.classList.add('fill-current')
          this.bellTarget.classList.add('text-red-500')
        } 
      } else {
        console.error('Network response was not ok.');
      }
    } catch (error) {
      console.error('There was a problem with the fetch operation:', error);
    }
  }
}
