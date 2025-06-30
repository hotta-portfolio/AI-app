# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@stripe/stripe-js", to: "@stripe--stripe-js.js" # @7.3.0
pin "stripe_payment"
pin "@rails/ujs", to: "rails-ujs.js"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "channels", to: "channels/index.js"
pin_all_from "app/javascript/channels", under: "channels"
pin "bootstrap" # @5.3.7
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
pin "knowhows/show", to: "knowhows/show.js"
