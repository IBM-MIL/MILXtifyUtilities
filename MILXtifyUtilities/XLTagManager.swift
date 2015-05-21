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
    * Sets a tag that has been updated recently
    **/
    func updatedTag(tag : XLTag) {
        self.recentTags.append(tag);
    }
    /**
    * Uploads updated tags to the Xtify service, does nothing if no tags have been
    **/
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
                XLappMgr.get().addTag(NSMutableArray(array: toBeUntagged));
            }
            self.tagsChanged = false;
            self.recentTags  = [XLTag]();
        }
    }
    /**
    * Lets the Manager know tags have changed
    **/
    func notifyTagsChanged(value : Bool){
        self.tagsChanged = value;
    }
}