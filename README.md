MILXtifyUtilities
=======================


MILXtifyUtilities is a collection of [Xtify](https://console.xtify.com/) utilities to make notifications easier to work with. The utilities consist of a notification data model, helper methods to save notifications in `NSUserDefaults` rich notification API helper method.

## Installation

Assuming you already have the [Xtify SDK implemented](http://developer.xtify.com/display/sdk/Getting+Started+with+Apple+Push+Notification+Service) in your project, copy all 4 swift files in the MILXtifyUtilities directory into your project.

## Usage

*To view a more complete demo of using these utilities, check out the `AppDelegate.swift` file in this repo.*

#### Receiving Notifications
1. Once you have received a notification through the `didReceiveRemoteNotification` method in AppDelegate, test to see if a Rich Notificaiton ID is present.
2. If so, setup DataUtils in order to retrieve the rich notification. Example:
	```swift
	var dataUtils = DataUtils()
	dataUtils.dataDelegate = self
	dataUtils.pendingNotificaitonRequest(value) // value is rich notification ID
	```
3. Setup the DataUtils delegate method.
        
        func pendingNotificationsReceived(jsonDictionary: NSDictionary)

#### Saving Notifications
1. Create a `NotificationData` object from the jsonDictionary received from the delegate method.
	`var notificationData = NotificationData(richNotificationJson: dictionaryData as Dictionary<NSObject, AnyObject>) `
2. Call the DataUtils method to save notification in `NSUserDefaults`.
	`DataUtils.saveNotificationLocally(notificationData)`
	
#### Read Locally Saved Notifications
1. Retrieve a `NotificationDataList` object like so.
        
        var dataList = NotificationDataList(key: "notificationData")
2. Optionally, if you have added all the categories you support in the `stringCategories` array at the top of `NotificationDataList.swift`, you can call `sortWithCategory` to only get the notifications you want.
        
        var filteredValues = dataList.sortWithCategory("Unread Notifications")
3. Lastly, if you want to sort your array of `NotificationData` objects by date, then call `sortByDate`.
        
        var sorted = NotificationDataList.sortByDate(filteredValues)

## NotificationDataList Methods
<table>
  <caption>Method Descriptions</caption>
  <tr>
    <td><tt>init(key: String) </tt></td>
    <td>Initializes and returns a NotificationDataList object. It will be populated with any data already saved locally.</td>
  </tr>
  <tr>
    <td><tt>class func loadSaved(key: String) -> NotificationDataList?</tt></td>
    <td>Convenience method to check if data has already been saved locally.</td>
  </tr>
  <tr>
    <td><tt>func add(data: NotificationData)</tt></td>
    <td>Adds a single NotificationData object to a NotificationDataList and to NSUserDefaults.</td>
  </tr>
    <tr>
    <td><tt>func remove(data: NotificationData)</tt></td>
    <td>Removes a single NotificationData object from a NotificationDataList and from NSUserDefaults.</td>
  </tr>
    <tr>
    <td><tt>func save()</tt></td>
    <td>Method to save all new, removed, or updated data in NSUserDefaults</td>
  </tr>
    <tr>
    <td><tt>func updateNotificationWithKey(dataObject: NotificationData)</tt></td>
    <td>Updates an existing NotificationData objects within the NotificationDataList</td>
  </tr>
    </tr>
    <tr>
    <td><tt>func clear()</tt></td>
    <td>Method to clear all NotificationDataList and NSUserDefaults data</td>
  </tr>
    </tr>
    <tr>
    <td><tt>func sortWithCategory(category: String) -> [NotificationData]</tt></td>
    <td>Method to filter data by category, ONLY use if you are using the category member on NotificationData</td>
  </tr>
    </tr>
    <tr>
    <td><tt>class func sortByDate(data: [NotificationData]) -> [NotificationData]</tt></td>
    <td>Method to sort a NotificationData array by timestamp (NSDate)</td>
  </tr>
</table>

<table>
  <caption>Global Variable Descriptions</caption>
  <tr>
    <td><tt>let stringCategories: [String]</tt></td>
    <td>Array of string categories that should be modified to match the categories you wan to to support, if any.</td>
  </tr>
</table>

## Requirements
* MILXtifyUtilities has only been tested to work with iOS 8+

## Author

Created by [Taylor Franklin](https://github.com/tfrank64)
([tfrank64](https://twitter.com/tfrank64)) at the [IBM Mobile Innovation Lab](http://www-969.ibm.com/innovation/milab/)

## License

MILXtifyUtilities is available under the Apache 2.0 license. See the LICENSE file for more info.

