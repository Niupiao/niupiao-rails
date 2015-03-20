[![Build Status](https://travis-ci.org/Niupiao/niupiao-rails.svg?branch=master)](https://travis-ci.org/Niupiao/niupiao-rails)

# Setup
Run `bundle install` if you haven't already done so.
Then run `rake db:drop db:create db:migrate db:seed` to create and seed a fresh database.
(You only have to do this once, unless new migrations are added).

# Testing on Mobile Devices
See [this guide](https://developer.chrome.com/devtools/docs/remote-debugging#port-forwarding) to learn how to setup testing with localhost for your Android device.
You must have Google Chrome.
I'm not sure about Safari for iOS.