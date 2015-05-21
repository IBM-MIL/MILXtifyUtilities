//
//  XLTag.swift
//  XtifyTesting
//
//  Created by Evan Compton on 5/20/15.

/**************************************
*
*  Licensed Materials - Property of IBM
*  © Copyright IBM Corporation 2015. All Rights Reserved.
*  This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer
*  (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product,
*  either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's
*  own products.
*
***************************************/

import Foundation
/**
 * This class represents an Xtify Tag
 **/
public class XLTag {
    //The tag name to use
    private var tagName : String;
    //Whether to set the tag on a user or unset it
    private var isSet : Bool;
    
    init(tagName : String, isSet : Bool) {
        self.tagName = tagName;
        self.isSet = isSet;
    }
    
    public func getTagName() -> String {
        return tagName;
    }
    
    public func setTagName(tagName : String) {
        self.tagName = tagName;
    }
    
    public func getIsSet() -> Bool {
        return isSet;
    }
    
    public func setIsSet(isSet : Bool) {
        self.isSet = isSet;
    }
}