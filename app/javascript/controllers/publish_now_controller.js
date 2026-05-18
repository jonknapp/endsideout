import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date"]

  setToday() {
    this.dateTarget.value = new Date().toISOString().split("T")[0]
    this.element.requestSubmit()
  }
}
