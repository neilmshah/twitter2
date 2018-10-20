//
//  AppDelegate.swift
//  twitter
//
//  Created by Neil Shah on 10/10/18.
//  Copyright © 2018 Neil Shah. All rights reserved.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Check for logged in user
        if User.current != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let timeLineViewController = storyboard.instantiateViewController(withIdentifier: "TimelineViewController") as! TimelineViewController
            //let tabBarController = UITabBarController.init(nibName: "TimelineViewController", bundle: nil)
            let navigationController = UINavigationController.init(rootViewController: timeLineViewController)
            window?.rootViewController = navigationController
            // Navigation Bar
            let navigationBarProperties = UINavigationBar.appearance()
            navigationBarProperties.barTintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
            navigationBarProperties.tintColor = UIColor.white
            navigationBarProperties.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("didLogout"), object: nil, queue: OperationQueue.main)
        {(Notification) in
            User.current = nil
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.window?.rootViewController = loginViewController
        }
        
        return true
    }
    
    // MARK: TODO: Open URL
    // OAuth step 2
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle urlcallback sent from Twitter
        APIManager.shared.handle(url: url)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

