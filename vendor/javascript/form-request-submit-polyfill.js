var e="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;(function(t){"function"!=typeof t.requestSubmit&&(t.requestSubmit=function(t){if(t){validateSubmitter(t,this||e);t.click()}else{t=document.createElement("input");t.type="submit";t.hidden=true;this.appendChild(t);t.click();this.removeChild(t)}});function validateSubmitter(e,t){e instanceof HTMLElement||raise(TypeError,"parameter 1 is not of type 'HTMLElement'");"submit"==e.type||raise(TypeError,"The specified element is not a submit button");e.form==t||raise(DOMException,"The specified element is not owned by this form element","NotFoundError")}function raise(e,t,i){throw new e("Failed to execute 'requestSubmit' on 'HTMLFormElement': "+t+".",i)}})(HTMLFormElement.prototype);var t={};export default t;

