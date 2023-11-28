// app/javascript/controllers/infinite_carousel_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['slide'];

  initialize() {
    this.currentIndex = 0;
    this.nextIndex = 1;
    this.changeSlide();
  }

  changeSlide() {
    setInterval(() => {
      this.nextIndex = (this.currentIndex + 1) % this.slideTargets.length;
      this.updateSlide();
    }, 5000);
  }

  updateSlide() {
    const currentSlide = this.slideTargets[this.currentIndex];
    const nextSlide = this.slideTargets[this.nextIndex];

    nextSlide.classList.remove('hidden');
    nextSlide.classList.add('slide-in-right');

    currentSlide.classList.add('slide-out-left');

    setTimeout(() => {
      currentSlide.classList.add('hidden');
      currentSlide.classList.remove('slide-out-left');
      nextSlide.classList.remove('slide-in-right');

      this.currentIndex = this.nextIndex;
    }, 5000);
  }
}
