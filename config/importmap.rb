# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "new.application", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "stimulus-reveal-controller" # @4.1.0
pin_all_from "app/javascript/controllers", under: "controllers"
pin "tom-select" # @1.7.8
