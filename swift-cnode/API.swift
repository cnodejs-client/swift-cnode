//
//  API.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/28.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import Alamofire
import SwiftyJSON

class API {
    static let LIMIT = 20
    static let BASE_URL = NSURL(string: "https://cnodejs.org/")!
    static let API_URL = "https://cnodejs.org/api/v1"
    static let TOPIC_LIST_API_URL = API_URL + "/topics"
    static let TOPIC_DETAIL_API_URL = API_URL + "/topic"
    static let ACCESS_TOKEN_URL = API_URL + "/accesstoken"
    static let USER_URL = API_URL + "/user"
    static let MESSAGES_COUNT_URL = API_URL + "/message/count"
    static let MESSAGES_URL = API_URL + "/messages"
    static let MARK_ALL_URL = API_URL + "/message/mark_all"
    
    // 话题列表
    static func getTopicList(page: Int? = nil, tab: String? = nil, limit: Int? = nil, error: (String) -> Void, success: [Topic] -> Void) {
        let page_str = page == nil ? "1" : String(page!)
        let tab_str = tab == nil ? "" : tab!
        let limit_str = limit == nil ? String(API.LIMIT) : String(limit)
        Alamofire.request(.GET, API.TOPIC_LIST_API_URL, parameters: [ "page": page_str, "tab": tab_str, "limit": limit_str ]).responseJSON { response in
            if response.result.isFailure {
                error(Error.NetError.rawValue)
                return
            }
            let json = JSON(response.result.value!)
            let data = json["data"]
            
            var topics = [Topic]()
            for (_, topic) in data {
                topics.append(Topic(topic))
            }
            success(topics)
        }
    }
    
    // 话题明细
    static func getTopicDetail(id: String, mdrender: String? = "", accesstoken: String? = "", error: (String) -> Void, success: Topic -> Void) {
        Alamofire.request(.GET, API.TOPIC_DETAIL_API_URL + "/" + id, parameters: [ "mdrender": mdrender!, "accesstoken": accesstoken! ]).responseJSON { response in
            if response.result.isFailure {
                error(Error.NetError.rawValue)
                return
            }
            let json = JSON(response.result.value!)
            let data = Topic(json["data"])
            success(data)
        }
    }
    //
    //    // 新建主题
    //    static func createTopic(token: String, title: String, tab: String, content: String, error: (String) -> Void, success: () -> ()) {
    //        Alamofire.request(.POST, API.TOPIC_LIST_API_URL, parameters: [
    //            "accesstoken": token,
    //            "title": title,
    //            "tab": tab,
    //            "content": content
    //            ]).responseJSON { response in
    //                self.process(response, error, done, success)
    //        }
    //    }
    //
    //    // 创建回复
    //    static func createReply(token: String, id: String, content: String, replyTo: String?,
    //                     error: (String) -> Void, success: () -> ())
    //    {
    //        Alamofire.request(.POST, "\(API.TOPIC_DETAIL_API_URL)/\(id)/replies", parameters: [
    //            "accesstoken": token,
    //            "content": content,
    //            "reply_id": replyTo == nil ? "" : replyTo!
    //            ]).responseJSON { response in self.process(response, error, done, success) }
    //    }
    //
    //    // 点赞或取消点赞
    //    static func thumbsReply(token: String, replyId: String, error: (String) -> Void, success: () -> ()) {
    //        Alamofire.request(.POST, "\(API.API_URL)/reply/\(replyId)/ups", parameters: [
    //            "accesstoken": token
    //            ]).responseJSON { response in
    //                self.process(response, error, done) { data in
    //                    success(data["data"])
    //                }
    //        }
    //    }
    //
    //    // 验证 Access Token 有效性
    //    static func validateToken(token: String, error: (String) -> Void, success: () -> ()) {
    //        Alamofire.request(.POST, API.ACCESS_TOKEN_URL, parameters: ["accesstoken": token]).responseJSON { response in
    //            self.process(response, error, done, success)
    //        }
    //    }
    //
    //    // 取得用户明细
    //    static func getUser(loginname: String, error: (String) -> Void, success: () -> ()) {
    //        Alamofire.request(.GET, API.USER_URL + "/" + loginname).responseJSON { response in
    //            self.process(response, error, done, success)
    //        }
    //    }
    //
    //    // 取得未读消息数
    //    static func getUnreadsCount(token: String, error: (String) -> Void, success: Int -> Void) {
    //        Alamofire.request(.GET, API.MESSAGES_COUNT_URL, parameters: ["accesstoken": token]).responseJSON { response in
    //            self.process(response, error, done) { data in
    //                success(data["data"].intValue)
    //            }
    //        }
    //    }
    //
    //    // 取得所有消息
    //    static func getMessages(token: String, error: (String) -> Void, success: () -> ()) {
    //        Alamofire.request(.GET, API.MESSAGES_URL, parameters: ["accesstoken": token]).responseJSON { response in
    //            self.process(response, error, done) { data in
    //                success(data["data"])
    //            }
    //        }
    //    }
    //
    //    // 将所有消息标记为已读
    //    static func markAllAsRead(token: String, error: (String) -> Void, success: () -> ()) {
    //        Alamofire.request(.POST, API.MARK_ALL_URL, parameters: ["accesstoken": token]).responseJSON { response in
    //            self.process(response, error, done) { data in
    //                success(data["data"])
    //            }
    //        }
    //    }
}