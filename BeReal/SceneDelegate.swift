//
//  SceneDelegate.swift
//  BeReal
//
//  Created by Bryan Puckett on 2/9/26.
//

import UIKit
import ParseSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        // Listen for login notification
        NotificationCenter.default.addObserver(forName: Notification.Name("login"),
                                               object: nil, queue: .main) { [weak self] _ in
            self?.login()
        }

        // Listen for logout notification
        NotificationCenter.default.addObserver(forName: Notification.Name("logout"),
                                               object: nil, queue: .main) { [weak self] _ in
            self?.logout()
        }

        // Check if user is already logged in (persist login)
        // Validate the session token before navigating to feed
        if User.current != nil {
            User.current?.fetch { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        // Session token is valid, proceed to feed
                        self?.login()
                    case .failure(_):
                        // Session token is invalid/expired, log out to clear local data and show login
                        // User.logout clears local keychain even if server call fails
                        User.logout { _ in
                            DispatchQueue.main.async {
                                self?.showLogin()
                            }
                        }
                    }
                }
            }
        }
    }

    private func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "FeedNavigationController")
        window?.rootViewController = navController
    }

    private func showLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        window?.rootViewController = loginVC
    }

    private func logout() {
        // User.logout always clears local keychain data, even when server call fails
        User.logout { [weak self] _ in
            DispatchQueue.main.async {
                self?.showLogin()
            }
        }
    }
}
