//
//  AppDelegate.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/09.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import NendAd

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        NADInterstitial.sharedInstance().loadAd(withSpotID: 213208, apiKey: "308c2499c75c4a192f03c02b2fcebd16dcb45cc9")
        if UserDefaults.standard.object(forKey: "userid") != nil{
            print("呼ばれてます")
            self.window = UIWindow(frame: UIScreen.main.bounds)
                  // ViewControllerをインスタンス化、windowのrootに設定する
            self.window!.rootViewController = TabbarController()
                  // 表示する
            self.window!.makeKeyAndVisible()
        }
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
    func applicationSignificantTimeChange(_ application: UIApplication) {
        print("---------------------------------------------------------")
        print("日付が変わりました")
        if let past_day = UserDefaults.standard.object(forKey: "lastTime") {
           
            let date = DateModel()
            let past = past_day as! Date
            print(date.checkDate(now: Date(), past: past))
        }
        print("---------------------------------------------------------")
       
    }


}

