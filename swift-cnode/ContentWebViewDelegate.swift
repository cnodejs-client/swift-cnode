//
//  ContentWebViewDelegate.swift
//  swift-cnode
//
//  Created by chenf on 4/17/16.
//  Copyright © 2016 nswbmw. All rights reserved.
//

import UIKit
import SafariServices

class ContentWebViewDelegate: NSObject, UIWebViewDelegate {
    let viewController: UIViewController

    init(_ vc: UIViewController) {
        viewController = vc
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL == API.BASE_URL) {
            return true;
        }

        let urlStr = request.URLString

        let baseUrlStr = API.BASE_URL.URLString
        let topicUrlPrefix = baseUrlStr + "topic/"
        let userUrlPrefix = baseUrlStr + "user/"

        let topicUrlRegex = topicUrlPrefix + "[a-z0-9]{24}$"
        let userUrlRegex = userUrlPrefix + "[a-zA-Z0-9-]+$"

        if (urlStr.rangeOfString(topicUrlRegex, options: .RegularExpressionSearch) != nil) {
            let topicId = urlStr.substringFromIndex(topicUrlPrefix.endIndex)

            API.getTopicDetail(topicId, error: { err in
                showToast(err)
            }, success: { topic in
                let topicVC = self.viewController.storyboard?.instantiateViewControllerWithIdentifier("TopicVC") as! TopicViewController
                topicVC.topic = topic
                self.viewController.navigationController?.pushViewController(topicVC, animated: true)
            })
        } else if (urlStr.rangeOfString(userUrlRegex, options: .RegularExpressionSearch) != nil) {
            let loginname = urlStr.substringFromIndex(userUrlPrefix.endIndex)

            API.getUser(loginname, error: { err in
                showToast(err)
            }, success: { author in
                let authorVC = self.viewController.storyboard?.instantiateViewControllerWithIdentifier("AuthorVC") as! AuthorViewController
                authorVC.author = author
                self.viewController.navigationController?.pushViewController(authorVC, animated: true)
            })
        } else {
            let safariVC = SFSafariViewController(URL: request.URL!)
            self.viewController.presentViewController(safariVC, animated: true, completion: nil)
        }

        return false
    }

}
