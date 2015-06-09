/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

/**
 *  String extension manipulate strings
 */
extension String {

    /**
    Method simply strips out any html within a string, note, this method needs to be called on the main thread
    
    :param: html string with html formatting
    
    :returns: string with no html
    */
    func htmlToText() -> String {

        var data = self.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)
        var attrStr = NSAttributedString(data: data!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ], documentAttributes: nil, error: nil)
        
        return attrStr!.string
    }
}