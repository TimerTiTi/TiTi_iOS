//
//  SceneDelegate.swift
//  Project_Timer
//
//  Created by Min_MacBook Pro on 2020/06/08.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let isFirst = UserDefaults.standard.value(forKey: "isFirst") as? Bool ?? true
        let VCNum = UserDefaults.standard.value(forKey: "VCNum") as? Int ?? 1
        
        if isFirst {
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: firstViewController.identifier)
        } else {
            let rootViewController: UITabBarController = storyboard.instantiateInitialViewController() as? UITabBarController ?? UITabBarController()
            if VCNum == 2 {
                rootViewController.selectedIndex = 1
            }
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.navigationBar.tintColor = UIColor.label
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = rootViewController
        }
        
        NotificationCenter.default.addObserver(forName: .showTabbarController, object: nil, queue: .main) { [weak self] _ in
            self?.showTabbarController()
        }
    }
    
    private func showTabbarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabbarController = storyboard.instantiateInitialViewController() else { return }
        let navigationController = UINavigationController(rootViewController: tabbarController)
        navigationController.navigationBar.tintColor = UIColor.label
        navigationController.isNavigationBarHidden = true
        
        let snapshot: UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
        navigationController.view.addSubview(snapshot)
        self.window?.rootViewController = navigationController
        
        UIView.animate(withDuration: 0.3) {
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        } completion: { _ in
            snapshot.removeFromSuperview()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

