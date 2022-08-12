//
//  AppDelegate.swift
//  WeathoMeter
//
//  Created by MobileAppDevelopment on 2022-08-09.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            UNUserNotificationCenter.current().delegate = self
            
            // Setup the NotificationCategories used in the future
            let foregroundAction = UNNotificationAction(identifier: "foregroundActionIdentifier", title: "foregroundAction", options: [.foreground])
            let category = UNNotificationCategory(identifier: "fooCategoryIdentifier", actions: [foregroundAction], intentIdentifiers: [], options: [.customDismissAction])
            UNUserNotificationCenter.current().setNotificationCategories([category])
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
        
        // In order to show a notification in banner mode, `completionHandler` must be called with suitable option here
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          print("userNotificationCenter - willPresent")
          completionHandler([.alert, .badge, .sound])
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("Clicked UNNotificationAction id: \(response.actionIdentifier)")
          completionHandler()
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
          // Developer should present the notification settings page here
          print("userNotificationCenter - openSettingsFor")
        }

}

