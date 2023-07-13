import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "e_wallet_app_v03", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          // This method is invoked on the UI thread.
          // Handle battery messages.
          if call.method == "CHECK_IS_ENROLL" {
              // TODO: Call method here
              result(self.checkEnroll())
          }
        })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func checkEnroll() -> Dictionary<String, Any>{
        let bio = Biometric()
        return bio.checkIsEnroll()
    }
}
