import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["levelSection", "destroy"]

  toggle(event) {
    const enrolled = event.target.checked
    this.levelSectionTarget.style.display = enrolled ? "" : "none"
    this.destroyTarget.value = enrolled ? "0" : "1"
  }
}
