import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController

    let batteryChannel = FlutterMethodChannel(
      name: "com.fittracker.app/battery",
      binaryMessenger: controller.binaryMessenger
    )

    batteryChannel.setMethodCallHandler { (call, result) in
      if call.method == "getBatteryLevel" {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel

        if level < 0 {
#if targetEnvironment(simulator)
          // No Simulator, o nivel de bateria nao e fornecido pela API.
          result(92)
#else
          result(FlutterError(
            code: "UNAVAILABLE",
            message: "Bateria indisponivel",
            details: nil
          ))
#endif
        } else {
          result(Int(level * 100))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
