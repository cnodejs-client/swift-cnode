//
//  Util.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/29.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import SwiftDate

class Util {
    static let DATE_TIME_FMT = DateFormat.Custom("yyyy-MM-dd HH:mm")
    static let ONE_MINUTE = 60.0
    static let ONE_HOUR = 60 * ONE_MINUTE
    static let ONE_DAY = 24 * ONE_HOUR
    static let ONE_MONTH = 30 * ONE_DAY

    class func fromNow(date: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let newDate = dateFormatter.dateFromString(date)
        
        let passed = abs(Double(newDate!.timeIntervalSinceNow))
        if passed > ONE_MONTH {
            return newDate!.toString(DATE_TIME_FMT)!
        } else if passed > ONE_DAY {
            return String(Int(passed / ONE_DAY)) + "天前"
        } else if passed > ONE_HOUR {
            return String(Int(passed / ONE_HOUR)) + "小时前"
        } else if passed > ONE_MINUTE {
            return String(Int(passed / ONE_MINUTE)) + "分钟前"
        } else {
            return "刚刚"
        }
    }

}