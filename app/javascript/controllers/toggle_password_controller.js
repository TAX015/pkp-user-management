import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fields", "checkbox"]

  connect() {
    this.toggle()
  }

  toggle() {
    if (this.hasCheckboxTarget) {
      if (this.checkboxTarget.checked) {
        this.fieldsTarget.classList.remove("hidden")
      } else {
        this.fieldsTarget.classList.add("hidden")
        this.fieldsTarget.querySelectorAll("input[type='password']").forEach(input => input.value = "")
      }
    }
  }
}