import { Controller } from "@hotwired/stimulus"

const exportOptions = {
  margin: 4,
  html2canvas: {
    scale: 4,
  },
  filename: 'output.pdf',
};

export default class extends Controller {
  static targets = ["spinner"]

  async export(event){
    const viewTarget = event.target.dataset.viewTarget;
    if (!viewTarget) return

    const exportTargetElement = document.querySelector(`[data-view="${viewTarget}"]`)
    if (!exportTargetElement) return

    this.showSpinner()

    await html2pdf()
      .set(exportOptions)
      .from(exportTargetElement)
      .save()
      .finally(() => this.hideSpinner())
  }

  showSpinner(){
    this.spinnerTarget.classList.remove("d-none")
  }

  hideSpinner(){
    this.spinnerTarget.classList.add("d-none")
  }
}
