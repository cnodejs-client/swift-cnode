//
//  User.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/27.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import Foundation

class Author : PPJSONSerialization {
    var loginname: String?
    var avatar_url: String?
    var githubUsername: String?
    var create_at: NSDate?
    var recent_topics: [Topic] = []
    var recent_replies: [Topic] = []
}