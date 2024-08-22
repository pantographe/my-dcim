import { Controller } from "@hotwired/stimulus"

import { get } from "@rails/request.js"
import { html2pdf, saveAs } from "html2pdf.js"

const exportOptions = {
  margin: 10,
  image: {
    type: "jpeg",
    quality: 1.0
  },
  pagebreak: { avoid: ".server" },
  enableLinks: false,
  html2canvas:  { width: 1200, scale: 2 },
  jsPDF: { format: "legal" }
}

export default class extends Controller {
  static targets = ["spinner"]
  static values = {
    modelIds: Array,
    filename: String
  }

  async export(event) {
    const viewTarget = event.target.dataset.viewTarget
    if (!viewTarget) return

    this.showSpinner()

    const pdfDoc = await this.generatePDF(viewTarget)
    const pdfBytes = await pdfDoc.save()
    const blob = new Blob([pdfBytes], { type: "application/pdf" })

    saveAs(blob, `${this.filenameValue}_${viewTarget}.pdf`)

    this.hideSpinner()
  }

  async generatePDF(viewTarget) {
    const pdfDoc = await PDFLib.PDFDocument.create();

    for (let i = 0; i < this.modelIdsValue.length; i++) {
      const modelId = this.modelIdsValue[i]

      const url = `/frames/${modelId}.pdf?view=${viewTarget}&debug=true`
      const response = await get(url, {
        responseKind: "application/pdf"
      })

      if (response.ok) {
        const html = await response.text

        const framePage = await html2pdf()
          .set(exportOptions)
          .from(html)
          .output("arraybuffer")

        const tmpDoc = await PDFLib.PDFDocument.load(framePage)
        const tmpPage = await pdfDoc.copyPages(tmpDoc, tmpDoc.getPageIndices())

        tmpPage.forEach((page) => pdfDoc.addPage(page))
      }
    }

    return pdfDoc
  }


  showSpinner() {
    this.spinnerTarget.classList.remove("d-none")
  }

  hideSpinner() {
    this.spinnerTarget.classList.add("d-none")
  }
}
