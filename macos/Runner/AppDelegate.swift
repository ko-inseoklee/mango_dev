import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

verride func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

    if (url.absoluteString.contains("thirdPartyLoginResult")) {
        return NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
    }

    return super.application(app, open: url, options: options)

}
