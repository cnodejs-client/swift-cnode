//
//  TopicViewController.swift
//  swift-cnode
//
//  Created by nswbmw on 16/4/3.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var contentWebView: UIWebView!

    var topic: Topic!

    override func viewDidLoad() {
        super.viewDidLoad()
        contentWebView.delegate = self

        topicTitle.text = topic.title
        avatar.kf_setImageWithURL(NSURL(string: topic.author.avatar_url)!)
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 5
        username.text = topic.author.loginname
        created.text = Tab(tab: topic.tab).rawValue + " • " + String(topic.visit_count) + "浏览 • " + String(topic.reply_count) + "回复 • " +  Util.fromNow(topic.last_reply_at)
        
        contentWebView.backgroundColor = UIColor.clearColor()
        contentWebView.opaque = false
        contentWebView.scrollView.showsVerticalScrollIndicator = false
        contentWebView.scrollView.bounces = false
        contentWebView.loadHTMLString(wrapContent(topic.content), baseURL: API.BASE_URL)
        contentWebView.scrollView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message.png"), style: .Plain, target: self, action: #selector(TopicViewController.show))
    }
    func show() {
        performSegueWithIdentifier("showComments", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let commentListViewController = segue.destinationViewController as! CommentListViewController
        commentListViewController.topicId = topic.id
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print(scrollView)
//    }

//    func webViewDidFinishLoad(webView: UIWebView) {
//        let x = Double(webView.frame.origin.x)
//        let y = Double(webView.frame.origin.y)
//        let width: Double = Double(webView.stringByEvaluatingJavaScriptFromString("document.body.offsetWidth")!)!
//        let height: Double = Double(webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")!)!
//        print(x, y, width, height, webView.frame.origin)
//        print(webView.frame)
//        webView.frame = CGRect(x: x, y: y, width: width, height: height)
//        webView.userInteractionEnabled = false
//    }
    
    func wrapContent(content: String) -> String {
        return "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"initial-scale=1, user-scalable=no, width=device-width\" /><style>html, body, div, p, img {width: 100%;word-break: break-all;word-wrap: break-word;} html, body { margin: 0; }</style></head><body>" + content + "</body></html>"
    }
    
}