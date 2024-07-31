import { Controller } from "@hotwired/stimulus"

const exportOptions = {
  margin: 4,
  html2canvas: {
    scale: 4,
  },
  filename: 'output.pdf',
};

export default class extends Controller {
  export(event){
    const viewTarget = event.target.dataset.viewTarget;
    if (!viewTarget) return

    const exportTargetElement = document.querySelector(`[data-view="${viewTarget}"]`)
    if (!exportTargetElement) return

    html2pdf().set(exportOptions).from(exportTargetElement).save();
  }
}
