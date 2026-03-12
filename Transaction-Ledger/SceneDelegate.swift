//
//  SceneDelegate.swift
//  Transaction-Ledger
//
//  Created by ATEU on 3/12/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            let window = UIWindow(windowScene: windowScene)
            
            // Instantiate our new, properly named View Controller
            let ledgerVC = TransactionListViewController()
            
            // Wrap it in a Navigation Controller
            let navVC = UINavigationController(rootViewController: ledgerVC)
            
            window.rootViewController = navVC
            self.window = window
            window.makeKeyAndVisible()
        }

        func sceneDidDisconnect(_ scene: UIScene) {}
        func sceneDidBecomeActive(_ scene: UIScene) {}
        func sceneWillResignActive(_ scene: UIScene) {}
        func sceneWillEnterForeground(_ scene: UIScene) {}
        func sceneDidEnterBackground(_ scene: UIScene) {}


}

