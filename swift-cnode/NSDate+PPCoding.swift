//
//  NSDateExtension.swift
//  swift-cnode
//
//  Created by chenf on 4/19/16.
//  Copyright © 2016 nswbmw. All rights reserved.
//

import Foundation

extension NSDate: PPCoding {
    func formatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }

    func encodeAsPPObject() -> AnyObject? {
        return formatter().stringFromDate(self)
    }

    func decodeWithPPObject(PPObject: AnyObject) -> AnyObject? {
        return formatter().dateFromString(PPObject as! String)
    }
}