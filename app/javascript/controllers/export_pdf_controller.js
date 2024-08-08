import { Controller } from "@hotwired/stimulus"

const exportOptions = {
  margin: 10,
  image: {
    type: "jpeg",
    quality: 1.0
  },
  enableLinks: false,
  pagebreak: { mode: "avoid-all" },
  html2canvas: { width: 1200 },
  filename: "frame.pdf",
}

export default class extends Controller {
  static targets = ["spinner"]

  async export(event){
    // const viewTarget = event.target.dataset.viewTarget
    // if (!viewTarget) return

    const exportTargetElement = document.querySelector(".container-fluid")
    if (!exportTargetElement) return

    // this.showSpinner()

    await html2pdf()
      .set(exportOptions)
      .from(exportTargetElement)
      .save()
      .finally()
  }

  showSpinner(){
    this.spinnerTarget.classList.remove("d-none")
  }

  hideSpinner(){
    this.spinnerTarget.classList.add("d-none")
  }
}
