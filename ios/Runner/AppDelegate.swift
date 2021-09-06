import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
     GeneratedPluginRegistrant.register(with: self)
    // TODO: Add your API key
        GMSServices.provideAPIKey("AIzaSyDWVUn_Q0IWtTFNdPhy57jgMfTCVEAvRX8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
