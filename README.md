#Meeper
*A Notifications Center plugin for Mac OS 10.10 (Yosemite) facilitating quick and easy control of iTunes.*

The plugin provides means for controlling iTunes, as well as displaying some basic metadata.
![Example](https://cloud.githubusercontent.com/assets/644002/5137817/df005540-7106-11e4-948f-a65a4c054c28.PNG)

Eventually, it will evolve to provide more features, like volume control, seeking, and so forth. Please, feel free to open an issue with any suggestions.

## How It Works
Under the hood, Meeper revolves around the private distributed notification sent out by iTunes whenever its playback state changes, `com.apple.iTunes.playerInfo`.

Meeper then uses ScriptingBridge to get various properties of the current track, including the artwork, rating, and so forth. This information is presented as readonly properties on the `TSiTunesController` class, which is instantiated in the NIB.

In this NIB, the various labels, buttons and image views are bound to the appropriate properties, and thus magically update whenever iTunes sends out a notification.

Additionally, when the extension is made visible after going off-screen, or initialised for the first time, a request for new information is made.

## License
Meeper is available under the terms of the two-clause BSD license. See `LICENSE.md` for the full terms.