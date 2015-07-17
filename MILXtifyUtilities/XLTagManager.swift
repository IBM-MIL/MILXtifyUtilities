/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

/**
* Helps manage adding or removing tags to a user and uploading them as
* a single bulk payload to the Xtify service
*/
public class XLTagManager {
    
    private var tagsChanged : Bool;
    private var recentTags : [XLTag];
    public static let sharedInstance = XLTagManager()
    
    init() {
        self.tagsChanged = false;
        self.recentTags  = [XLTag]();
    }
    
    /**
    Method to add tags to local recent tags, to be used later in server update
    
    :param: tag XLTag to add
    */
    func updatedTag(tag : XLTag) {
        self.recentTags.append(tag);
    }
    
    /**
    Method to update server with tags to be added and removed
    */
    func sendTagsToServerBulk() {
        if(!tagsChanged) {
            return;
        }
        
        var xtifyID : String? = XLappMgr.get().getXid();
        if let xid = xtifyID {
            var tagdic : [XLTag] = self.recentTags;
            
            var toBeTagged = [String]();
            var toBeUntagged = [String]();
            for tag in tagdic {
                if(tag.getIsSet()) {
                    toBeTagged.append(tag.getTagName());
                } else {
                    toBeUntagged.append(tag.getTagName());
                }
            }
            
            if(toBeTagged.count > 0) {
                XLappMgr.get().addTag(NSMutableArray(array: toBeTagged));
            }
            if(toBeUntagged.count > 0) {
                XLappMgr.get().unTag(NSMutableArray(array: toBeUntagged))
            }
            self.tagsChanged = false;
            self.recentTags  = [XLTag]();
        }
    }
    
    /**
    Method to notifiy XLTagManager that tags have been changed and should be updated later
    
    :param: value boolean to dermine if tags changed
    */
    func notifyTagsChanged(value : Bool){
        self.tagsChanged = value;
    }
    
    /**
    Simplified bulk tag update which sets an array of tags to be updated and then calls `sendTagsToServerBulk`
    
    :param: tags   array of tags in string format
    :param: toKeep if true, we are adding tags in array, if false, we are removing all tags in array
    */
    func updateWithTags(tags: [String], toKeep: Bool) {
        
        for tag in tags {
            XLTagManager.sharedInstance.updatedTag(XLTag(tagName: tag, isSet: toKeep))
        }
        
        XLTagManager.sharedInstance.notifyTagsChanged(true)
        XLTagManager.sharedInstance.sendTagsToServerBulk()
        
    }
    
    /**
    Helper metho to simply reset all tags for this user on the Xtify servers
    */
    func resetRemoteTags() {
        XLappMgr.get().setTag(NSMutableArray())
    }
}