//
//  AppDelegate.swift
//  Project_Timer
//
//  Created by Min_MacBook Pro on 2020/06/08.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics
import GoogleMobileAds
import WidgetKit
import GoogleSignIn

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    // 화면 회전을 제어할 변수 선언
    var shouldSupportPortraitOrientation = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.checkLatestVersion()
        self.checkGoogleSignOut()
        
        if Infos.isDevMode == false {
            self.configureGoogleAdmob()
        }
        
        self.configureNotificationCenterAddObserver()
        self.configureMacCatalyst()
        self.configureSharedUserDefaults()
        self.configureWidget()
        
        self.checkSignined()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    // MARK: Contigure Rotation
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if shouldSupportPortraitOrientation {
            return .portrait
        } else {
            return .all
        }
    }
    
    // MARK: Redirection
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
}

/// Foreground 모드에서 notification 알림을 설정하기 위한 부분
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

// MARK: Configure
extension AppDelegate {
    private func checkLatestVersion() {
        /// 최신버전 체크로직
        guard UserDefaultsManager.get(forKey: .updatePushable) as? Bool ?? true else { return }
        NetworkController(network: Network()).getAppstoreVersion { result in
            switch result {
            case .success(let storeVersion):
                if storeVersion.compare(String.currentVersion, options: .numeric) == .orderedDescending {
                    let message = "Please download the ".localized() + storeVersion + " version of the App Store :)".localized()
                    let alert = UIAlertController(title: "Update new version".localized(), message: message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Not now", style: .default)
                    let update = UIAlertAction(title: "UPDATE", style: .default, handler: { _ in
                        if let url = URL(string: NetworkURL.appstore),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:])
                        }
                    })
                    
                    alert.addAction(ok)
                    alert.addAction(update)
                    SceneDelegate.sharedWindow?.rootViewController?.present(alert, animated: true)
                }
            case .failure(let error):
                print(error.alertMessage)
            }
        }
    }
    
    private func checkGoogleSignOut() {
        /// 사용자의 로그인 상태 복원 시도
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // MARK: SignOut 구현
                GIDSignIn.sharedInstance.signOut()
                print("Show the app's signed-out state")
            } else {
                // MARK: SignIn 관련 로직 필요한지 확인 필요
                print("Show the app's signed-in state")
            }
        }
    }
    
    private func configureGoogleAdmob() {
        /// 애드몹 이니셜라이즈
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        /// 앱 실행시 Analytics 에 정보 전달부분
        FirebaseApp.configure()
        Analytics.logEvent("launch", parameters: [
            AnalyticsParameterItemID: "ver \(String.currentVersion)",
        ])
    }
    
    private func configureNotificationCenterAddObserver() {
        /// Foreground 에서 알림설정을 활성화 하기 위한 delegate 연결 부분
        UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(forName: .setBadge, object: nil, queue: .current) { _ in
            UIApplication.shared.applicationIconBadgeNumber = 1
        }
        NotificationCenter.default.addObserver(forName: .removeBadge, object: nil, queue: .current) { _ in
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    private func configureMacCatalyst() {
        /// Mac 의 경우 Control 옵션 비활성화
        #if targetEnvironment(macCatalyst)
        UserDefaultsManager.set(to: false, forKey: .keepTheScreenOn)
        UserDefaultsManager.set(to: false, forKey: .flipToStartRecording)
        #endif
    }
    
    private func configureSharedUserDefaults() {
        /// UserDefaults.standard -> shared 반영
        if Versions.check(forKey: .updateSharedUserDefaultsCheckVer) {
            UserDefaults.updateShared()
            Versions.update(forKey: .updateSharedUserDefaultsCheckVer)
        }
    }
    
    private func configureWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: "CalendarWidget")
    }
    
    private func checkSignined() {
        /// signout 상태의 경우 KeyChain 초기화
        let signined = UserDefaultsManager.get(forKey: .signinInTestServerV1) as? Bool ?? false
        if signined == false {
            print("not signined")
            guard KeyChain.shared.deleteAll() else {
                print("ERROR: KeyChain.shared.deleteAll")
                return
            }
        }
    }
}
