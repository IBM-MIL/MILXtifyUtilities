/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dataList = NotificationDataList(key: "notificationData")
        let filteredValues = dataList.sortWithCategory("Unread Notifications")
        _ = NotificationDataList.sortByDate(filteredValues)
        
        // TODO: create more elaborate example view to display notifications
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

