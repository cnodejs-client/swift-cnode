//
//  Topic.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/27.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import Foundation

class Topic : PPJSONSerialization {
    var id: String?
    var author_id: String?
    var tab: String?
    var content: String?
    var title: String?
    var last_reply_at: NSDate?
    var good: Bool = false
    var top: Bool = false
    var reply_count: Int = 0
    var visit_count: Int = 0
    var create_at: NSDate?
    var author: Author?
    var replies: [Comment] = []
    var is_collect: Bool = false
}