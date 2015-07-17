/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, DataUtilsDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {

    }

    func applicationDidEnterBackground(application: UIApplication) {
        println("Application is about to Enter Background")
        
        XLappMgr.get().appEnterBackground()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        println("Application moved to Foreground")
        
        XLappMgr.get().appEnterForeground()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        println("Application moved from inactive to Active state")
        
        XLappMgr.get().appEnterActive()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        println("applicationWillTerminate")
        
        XLappMgr.get().applicationWillTerminate()
    }
    
    /* Xtify Notification Handling */
    
    override init() {
        super.init()
        
        var anXtifyOptions = XLXtifyOptions.getXtifyOptions()
        XLappMgr.get().initilizeXoptions(anXtifyOptions)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("Succeeded registering for push notifications. Dev Token: \(deviceToken)")
        XLappMgr.get().registerWithXtify(deviceToken)
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        println("Recieving notification from any app state")
        
        var launchOptions = userInfo
        self.handleAnyNotification(launchOptions)
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Failed to register with error: \(error)")
        XLappMgr.get().registerWithXtify(nil)
    }
    
    // MARK: Notification handling methods
    
    /**
    Method that all notifications must go through, including when app is active and when coming from an inactive state
    
    :param: receivedData data received from notification
    */
    func handleAnyNotification(receivedData: Dictionary<NSObject,AnyObject>) {
        println("DATA: \(receivedData)")
        
        if receivedData.isEmpty {
            return
        }
        
        if let value = receivedData["RN"] as? String {
            
            var dataUtils = DataUtils()
            dataUtils.dataDelegate = self
            dataUtils.richNotificationsRequest(value)
            return
        }
        
        self.handleSimplePush(receivedData)
    }
    
    /**
    Method to handle simple notifications and display them to user
    
    :param: receivedData json data received from Xtify
    */
    func handleSimplePush(receivedData: Dictionary<NSObject, AnyObject>) {
        
        // Save incoming notification data locally
        var notificationData = NotificationData(notificationJson: receivedData)
        var dataList = DataUtils.saveNotificationLocally(notificationData)
        
        // Alerts have no other purpose than to allow you to see the notification data on your device
        var alertView = UIAlertController(title: notificationData.title, message: notificationData.body + notificationData.keyTimestamp, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default, handler: nil))
        self.window?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)
    }

    /**
    Delegate method to receive json data from API call
    
    :param: jsonDictionary a dictionary of json data from Xtify
    */
    func richNotificationsReceived(jsonDictionary: NSDictionary) {
        
        if let response = jsonDictionary["response"] as? String {
            
            if jsonDictionary.count > 0 && response == "SUCCESS" {
                println("Result: \(jsonDictionary)")
                
                if let messages = jsonDictionary["messages"] as? NSArray {
                    dispatch_async(dispatch_get_main_queue(),{
                        for dictionaryData in messages {
                            var notificationData = NotificationData(richNotificationJson: dictionaryData as! Dictionary<NSObject, AnyObject>)
                            DataUtils.saveNotificationLocally(notificationData)
                            
                            // Alerts have no other purpose than to allow you to see the notification data on your device
                            var alertView = UIAlertController(title: notificationData.title, message: notificationData.body, preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default, handler: nil))
                            self.window?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
}

