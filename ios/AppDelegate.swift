//
//  AppDelegate.swift
//  LivePerson
//
//  Created by David Villacis on 12/15/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation
// Required LivePerson Import
import LPMessagingSDK
// Required Notification Import
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LPMessagingSDKNotificationDelegate{
  
  // Reference to MainScreen
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    // Get Bundle from React
    let jsCodeLocation = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
    // Get Root View from React
    let rootView = RCTRootView(bundleURL: jsCodeLocation, moduleName: "LivePerson", initialProperties: nil, launchOptions: launchOptions)
    // Set Root View Background Color
    rootView?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    // Set Window Frae
    self.window = UIWindow(frame: UIScreen.main.bounds)
    // Create New ViewController
    let rootViewController = UIViewController()
    // Set React View on ViewController
    rootViewController.view = rootView
    // Set ViewController as Root
    self.window?.rootViewController = rootViewController
    // Make Visible
    self.window?.makeKeyAndVisible()
    // Register Push Notification
    self.registerforPushNotification(application)
    // Set Application Status Bar Style to Dark
    application.statusBarStyle = .default
    // Will remove Badge Number when Application is Open
    if application.applicationState == .background || application.applicationState == .inactive {
      // Reset Badge
      UIApplication.shared.applicationIconBadgeNumber = -1
    }
    // Return
    return true
  }
  
  // MARK: - Notification
  
  /// Will register for Push Notifications
  ///
  /// - Parameter application: UIApplication
  func registerforPushNotification(_ application: UIApplication){
    if #available(iOS 10.0, *) {
      // Register for Push Remote Notifications
      UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { (granted, error) in
        // Check if Granted Permissions
        if granted {
          // Dispatch Async Queue
          DispatchQueue.main.async {
            // Register for Push
            application.registerForRemoteNotifications()
          }
        }
      })
    } else {
      // Register for Push Notification - Deprecated on iOS 10.0
      application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil))
      // Register for Notifications
      application.registerForRemoteNotifications()
    }
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Get Token & Parse it
    let token = deviceToken.map{ String( format : "%02.2hhx",$0)}.joined()
    // Print Token
    print("Token:: \(token)")
    // Register Token on LPMesssaging Instance
    LPMessagingSDK.instance.registerPushNotifications(token: deviceToken, notificationDelegate: self)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Handle Push Notification
    LPMessagingSDK.instance.handlePush(userInfo)
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    
  }
  
  // MARK: - LPMessagingSDKNotificationDelegate Delegate
  
  /// Will handle custom behavior if received LP Push Notification
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  func LPMessagingSDKNotification(didReceivePushNotification notification: LPNotification) {
    
  }
  
  /// This method will hide/show the In-App Push Notification
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  /// - Returns: true for showing / false for hidding In-App Push Notification
  func LPMessagingSDKNotification(shouldShowPushNotification notification: LPNotification) -> Bool {
    // Return false if you don't want to show In-App Push Notification
    return true
  }
  
  
  /// Override SDK - In-App Push Notification
  /// Behavior for tapping In-App Notification should be handle, when using a custom view no behavior is added, LPMessagingSDKNotification(notificationTapped) can't be use
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  /// - Returns: Custom In-App Toast View
  func LPMessagingSDKNotification(customLocalPushNotificationView notification: LPNotification) -> UIView {
    // Get View
    let toast = Toast().getView(message: notification.text)
    // Return In-App Toast
    return toast
  }
  
  /// This method is override when using a Custom View for the Toast Notification (LPMessagingSDKNotification(customLocalPushNotificationView)
  /// Add Custom Behavior to LPMessaging Toast View being Tap
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  func LPMessagingSDKNotification(notificationTapped notification: LPNotification) {
    
  }
}

