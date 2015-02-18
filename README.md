# Setup
Run `bundle install` if you haven't already done so.
Then run `rake db:drop db:create db:migrate db:seed` to create and seed a fresh database.
(You only have to do this once, unless new migrations are added).

# Testing on Mobile Devices
I suggest you find some way of port forwarding.
[Google Chrome will do this excellently](https://developer.chrome.com/devtools/docs/remote-debugging#port-forwarding).
I'm not sure about Safari for iOS.

## Logging in on Mobile
When you try to login on mobile, look at `db/seeds.rb` to see what users are being created.
E.g., at one point in time, I seeded `kmc3` as the username and `foobar` as the password.
Feel free to use those credentials.