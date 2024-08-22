import { Controller } from "@hotwired/stimulus"

import { get } from "@rails/request.js"
import { html2pdf, jsPDF } from "html2pdf.js"

const exportOptions = {
  margin: 0.25,
  image: {
    type: "jpeg",
    quality: 1.0
  },
  enableLinks: false,
  // pagebreak: { mode: "css" },
  // html2canvas: { dpi: 192, letterRendering: true, scale: 2, width: 1200 },
  pagebreak: {
    mode: "avoid-all",
  },
  // html2canvas:  { scale: 3 },
  // jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
  // jsPDF: { format: "legal" }
}

export default class extends Controller {
  static targets = ["spinner"]
  static values = {
    modelIds: Array
  }

  async export(event) {
    const viewTarget = event.target.dataset.viewTarget
    if (!viewTarget) return

    this.showSpinner()

    const pdf = await this.generatePDF(viewTarget)
    pdf.save("filename")

    this.hideSpinner()
  }

  async generatePDF(viewTarget) {
    const doc = new jsPDF(exportOptions.jsPDF)
    // const pageSize = jsPDF.getPageSize(exportOptions.jsPDF)

    for (let i = 0; i < this.modelIdsValue.length; i++) {
      const modelId = this.modelIdsValue[i]

      const url = `/frames/${modelId}.pdf?view=${viewTarget}`
      const response = await get(url, {
        responseKind: "application/pdf"
      })

      if (response.ok) {
        const html = await response.text

        const framePage = await html2pdf()
          .set(exportOptions)
          .from(html)
          .toPdf()

        if (i != 0) doc.addPage()
        doc.addImage(framePage.src, "jpeg", exportOptions.margin, exportOptions.margin, framePage.width / 400, framePage.height / 400)
      }
    }

    return doc
  }


  showSpinner() {
    this.spinnerTarget.classList.remove("d-none")
  }

  hideSpinner() {
    this.spinnerTarget.classList.add("d-none")
  }
}
