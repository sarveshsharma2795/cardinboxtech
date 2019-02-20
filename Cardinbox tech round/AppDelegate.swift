//
//  AppDelegate.swift
//  Cardinbox tech round
//
//  Created by Sarvesh on 20/02/19.
//  Copyright © 2019 Sarvesh. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let center =  UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (result, error) in
            print(result)
        }
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
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

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let model = GetInformation()
        let url = "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=CNY&apikey=\(GlobalConstants.apiKey)"
        
        model.makeCurrencyRequest(withURL: URL(string: url)!, {
            (rate, statusCode) in
            if GlobalConstants.STATUS_OK ~= statusCode!{
                let center =  UNUserNotificationCenter.current()
                
                //create the content for the notification
                let content = UNMutableNotificationContent()
                content.title = " Currency rate"
                content.subtitle = "BTC TO CNY"
                content.body = "\((rate?.exchangeKey.exchangeRate ?? ""))"
                content.sound = UNNotificationSound.default
                
                //notification trigger can be based on time, calendar or location
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval:300.0, repeats: true)
                
                //create request to display
                let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
                
                //add request to notification center
                center.add(request) { (error) in
                    if error != nil {
                        print("error \(String(describing: error))")
                    }
                    completionHandler(.newData)
                }
            }
        })
    }
}
