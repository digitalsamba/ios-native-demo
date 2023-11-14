#  DigitalSamba native app example

This example media device permissions to be present in `Info.plist`, namely "Privacy - Microphone Usage Description" and "Privacy - Camera Usage Description".

There are a few components to this example. We create JS environment for embedded app in `frame.html`, similarly to how we would do on web.
Few things of note
* we create a plain frame without any adornments (so that it better fits native view) and load it immediately
* room URL can be configured in multiple ways. We support dynamic room URL by passing it as a part of query string from native app. Alternatively, it can be hardcoded in `frame.html` or, you could pass room properties inside `evaluateJavaScript()` call for more drill-down configuration
* `frame.html` comes with SDK version from the CDN. Integrators might want to bundle js files locally and include them during build time

Native app loads JS environment using WKWebView class, see `ViewController.swift` for details. In the example we simply load the frame and expose `view.sendCommand` method that allows executing arbitrary commands against SDK handle. See [docs](https://docs.digitalsamba.com/reference/sdk/digitalsambaembedded-class) for details on available commands and payloads.
Native app exposes a `messageHandler` (available as `window.webkit.messageHandlers.messageHandler` in JS environment) to listen to embedded app events. Multiple listeners can be set up for different events.
