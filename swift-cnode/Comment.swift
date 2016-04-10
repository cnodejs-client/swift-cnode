//
//  Comment.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/27.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import SwiftyJSON

struct Comment {
    let id: String!
    let author: Author!
    let content: String!
    let ups: [String]!
    let create_at: String!
    let reply_id: String?

    init(_ comment: JSON) {
        self.id = comment["id"].string
        self.author = Author(comment["author"])
        self.content = comment["content"].string
        
        var _ups = [String]()
        for var uid in comment["ups"].arrayValue {
            _ups.append(uid.string!)
        }
        self.ups = _ups

        
        self.create_at = comment["create_at"].string
        self.reply_id = comment["reply_id"].string
    }
}