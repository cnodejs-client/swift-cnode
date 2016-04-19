//
//  Comment.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/27.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import Foundation

class Comment : PPJSONSerialization {
    var id: String?
    var author: Author?
    var content: String?
    var ups: [String] = []
    var create_at: NSDate?
    var reply_id: String?
}