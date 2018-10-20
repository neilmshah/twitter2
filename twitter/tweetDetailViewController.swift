//
//  tweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Neil Shah on 10/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class tweetDetailViewController: UIViewController {

    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var faveCountLabel: UILabel!
    
    var tweet : Tweet?
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTweetInfo()
    }
    
    func loadTweetInfo() {
        if let tweet = self.tweet {
            let user = tweet.user
            timestampLabel.text = tweet.createdAtString
            tweetTextLabel.text = tweet.text
            tweetCountLabel.text = "\(tweet.retweetCount!)"
            faveCountLabel.text = "\(tweet.favoriteCount!)"
            fullNameLabel.text = user.name
            usernameLabel.text = "@\(user.screenName )"
            if let propicURL = user.profilepic {
                profilePicImageView.af_setImage(withURL: propicURL)
            }
        }
    }
    
    @IBAction func onTapReply(_ sender: Any) {
        self.performSegue(withIdentifier: "composeReplySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "composeReplySegue") {
            if let composeView = segue.destination as? composeViewController {
                //composeView.user = User.current
                composeView.isReply = true
                composeView.replyName = user?.screenName
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
