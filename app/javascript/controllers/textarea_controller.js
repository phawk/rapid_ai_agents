import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleKeydown(event) {
    if (event.key === 'Enter') {
      // If shift key is not pressed, submit the form
      if (!event.shiftKey) {
        event.preventDefault()
        this.element.form.requestSubmit()
      }
    }
  }
}
