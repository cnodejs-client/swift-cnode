//
//  AuthorViewController.swift
//  swift-cnode
//
//  Created by chenf on 4/20/16.
//  Copyright © 2016 nswbmw. All rights reserved.
//

import UIKit

class AuthorViewController: UITableViewController {
    var author: Author!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return author.recent_topics.count
        case 2: return author.recent_replies.count
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("AuthorCell") as! AuthorCell
            cell.avatarImageView.kf_setImageWithURL(NSURL(string: author.avatar_url!)!)
            cell.loginnameLabel.text = author.loginname
            cell.signupTimeLabel.text = Util.fromNow(author.create_at!)
            return cell
        default:
            if indexPath.section == 1 || indexPath.section == 2 {
                let topic = indexPath.section == 1 ? author.recent_topics[indexPath.row] : author.recent_replies[indexPath.row]

                let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell") as! TopicCell
                cell.authorAvatarImageView.kf_setImageWithURL(NSURL(string: topic.author!.avatar_url!)!)
                cell.authorNameLabel.text = topic.author!.loginname
                cell.titleLabel.text = topic.title
                cell.lastReplyTimeLabel.text = Util.fromNow(topic.last_reply_at!)
                return cell
            }

            return UITableViewCell()
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 1: return "最近主题"
        case 2: return "最近回复"
        default: return " "
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 || indexPath.section == 2 {
            let topic = indexPath.section == 1 ? author.recent_topics[indexPath.row] : author.recent_replies[indexPath.row]

            // recent_topics和recent_replies中的topic仅包含标题，作者等信息，不包括内容，因此需要重新获取
            API.getTopicDetail(topic.id!, error: { err in
                showToast(err)
            }, success: { _topic in
                let topicVC = self.storyboard?.instantiateViewControllerWithIdentifier("TopicVC") as! TopicViewController
                topicVC.topic = _topic
                self.navigationController?.pushViewController(topicVC, animated: true)
            })


        }
    }
}
