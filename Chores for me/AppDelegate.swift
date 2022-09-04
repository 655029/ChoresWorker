//
//  AppDelegate.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import GoogleMaps
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let googleApiKey = "AIzaSyBUtri-KhMgmjI5_Ddd360Po167EQ7P2fQ"
    var window: UIWindow?
    lazy private var router = RootRouter()
    lazy private var deeplinkHandler = DeeplinkHandler()
    lazy private var notificationsHandler = NotificationsHandler()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.      
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        Thread.sleep(forTimeInterval: 5.0)
        DropDown.startListeningToKeyboard()
        GMSServices.provideAPIKey(googleApiKey)
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "488113538675-3r77ldpbb36cchllgmats2791u4sfsc7.apps.googleusercontent.com"
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        if #available(iOS 13.0, *) {
            
        }else {
            router.loadMainAppStructure()
        }
        Router.default.setupAppNavigation(appNavigation: AppNavigation())
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses.append(ChooseYourCityViewController.self)
        // setRoot()
        setRootController()
        registerLocal(application: application)
        //Messaging.messaging().delegate = self
        
        //        let pushManager = PushNotificationManager(userID: "currently_logged_in_user_id")
        //        pushManager.registerForPushNotifications()
        
        //notificationsHandler.registerForRemoteNotifications()
        //notificationsHandler.configure()
        application.applicationIconBadgeNumber = 0
        return true
    }
    func registerLocal(application:UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Permission Granted!")
                Messaging.messaging().token { token, error in
                    if let error = error {
                        print("Error fetching FCM registration token: \(error)")
                    } else if let token = token {
                        print("FCM registration token: \(token)")
                        UserStoreSingleton.shared.fcmToken = token
                    }
                }
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("Permission Dennied")
            }
        }
    }
    func setRootController(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        } else {}
        if let window = self.window{
            let isLogin = UserStoreSingleton.shared.isLoggedIn
            _ = UserStoreSingleton.shared.Token
            if(isLogin ?? false){
                let isLocationEnabled = UserStoreSingleton.shared.isLocationEnbled
                if isLocationEnabled ?? false {
                    RootRouter().loadMainHomeStructure()
                }
                else {
                    let viewController = BaseNavigationController(rootViewController: Storyboard.Authentication.viewController(for: AllowLocationViewController.self))
                    viewController.view.layoutIfNeeded()
                    window.rootViewController = viewController
                }
            }else{
                let viewController = BaseNavigationController(rootViewController: Storyboard.Authentication.viewController(for: LoginViewController.self))
                viewController.view.layoutIfNeeded()
                window.rootViewController = viewController
                print("Token","Null")
            }
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            }, completion: nil)
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // To enable full universal link functionality add and configure the associated domain capability
        // https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            deeplinkHandler.handleDeeplink(with: url)
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
extension AppDelegate:MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        //      let dataDict:[String: String] = ["token": fcmToken ?? ""]
        //      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}
//@available(iOS 13.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)

        NotifiationDataHandle(notification: notification)


//        if notificationType == "request" {
//            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
//            let secondVc = storyboard.instantiateViewController(withIdentifier: "NewBookingViewController")
//
//            window?.rootViewController?.present(secondVc, animated: true, completion: nil)
//        }

        NotificationCenter.default.post(name: Notification.Name(rawValue: "Forground"), object: nil)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        NotifiationDataHandle(notification: notification)
        completionHandler()
    }

    func NotifiationDataHandle(notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
     //  print(userInfo)
       if let notificationType = userInfo[AnyHashable("notificationtype")] as? String {
        //   print(notificationType)
               let jobId  = userInfo[AnyHashable("jobId")]
           let str = Int(jobId as? String ?? "0")
           //print(str!)
           UserStoreSingleton.shared.id = str
           //RootRouter().loadMainHomeStructure()
           NotificationCenter.default.post(name:NSNotification.Name(rawValue: "notificationData"), object: ["notificationType": notificationType], userInfo: nil)
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // To enable full remote notifications functionality you should first register the device with your api service
        //https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/
        //notificationsHandler.handleRemoteNotification(with: userInfo)
        print(userInfo)
        
    }
}



