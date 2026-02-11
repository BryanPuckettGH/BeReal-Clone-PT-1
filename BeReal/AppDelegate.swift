//
//  AppDelegate.swift
//  BeReal
//
//  Created by Bryan Puckett on 2/9/26.
//

import UIKit
import ParseSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ParseSwift.initialize(applicationId: "WHl6ztvTljNJRofZPEGFrJPuCItPM2X6qxS0ciJa",
                              clientKey: "DfVIfqGbg0kmoA021MHA4kwq0tASPPV327feuv8l",
                              serverURL: URL(string: "https://parseapi.back4app.com")!)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
