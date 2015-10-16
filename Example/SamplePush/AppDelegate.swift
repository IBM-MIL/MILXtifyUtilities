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
        print("Application is about to Enter Background")
        
        XLappMgr.get().appEnterBackground()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        print("Application moved to Foreground")
        
        XLappMgr.get().appEnterForeground()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("Application moved from inactive to Active state")
        
        XLappMgr.get().appEnterActive()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        print("applicationWillTerminate")
        
        XLappMgr.get().applicationWillTerminate()
    }
    
    /* Xtify Notification Handling */
    
    override init() {
        super.init()
        
        let anXtifyOptions = XLXtifyOptions.getXtifyOptions()
        XLappMgr.get().initilizeXoptions(anXtifyOptions)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Succeeded registering for push notifications. Dev Token: \(deviceToken)")
        XLappMgr.get().registerWithXtify(deviceToken)
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("Recieving notification from any app state")
        
        let launchOptions = userInfo
        self.handleAnyNotification(launchOptions)
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register with error: \(error)")
        XLappMgr.get().registerWithXtify(nil)
    }
    
    // MARK: Notification handling methods
    
    /**
    Method that all notifications must go through, including when app is active and when coming from an inactive state
    
    :param: receivedData data received from notification
    */
    func handleAnyNotification(receivedData: Dictionary<NSObject,AnyObject>) {
        print("DATA: \(receivedData)")
        
        if receivedData.isEmpty {
            return
        }
        
        if let value = receivedData["RN"] as? String {
            
            let dataUtils = DataUtils()
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
        let notificationData = NotificationData(notificationJson: receivedData)
        DataUtils.saveNotificationLocally(notificationData)
        
        // Alerts have no other purpose than to allow you to see the notification data on your device
        let alertView = UIAlertController(title: notificationData.title, message: notificationData.body + notificationData.keyTimestamp, preferredStyle: .Alert)
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
                print("Result: \(jsonDictionary)")
                
                if let messages = jsonDictionary["messages"] as? NSArray {
                    dispatch_async(dispatch_get_main_queue(),{
                        for dictionaryData in messages {
                            let notificationData = NotificationData(richNotificationJson: dictionaryData as! Dictionary<NSObject, AnyObject>)
                            DataUtils.saveNotificationLocally(notificationData)
                            
                            // Alerts have no other purpose than to allow you to see the notification data on your device
                            let alertView = UIAlertController(title: notificationData.title, message: notificationData.body, preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default, handler: nil))
                            self.window?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
}

