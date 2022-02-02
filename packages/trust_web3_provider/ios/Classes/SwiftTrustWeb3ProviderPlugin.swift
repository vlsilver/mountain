import Flutter
import UIKit

public class SwiftTrustWeb3ProviderPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "trust_web3_provider", binaryMessenger: registrar.messenger())
    let instance = SwiftTrustWeb3ProviderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
