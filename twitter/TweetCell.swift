//
//  TweetCell.swift
//  twitter
//
//  Created by Neil Shah on 10/10/18.
//  Copyright © 2018 Neil Shah. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {

    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var parentView : TimelineViewController?
    var indexPath : IndexPath?
    
    var tweet : Tweet? {
        didSet{
            timeStampLabel.text = tweet?.createdAtString
            tweetTextLabel.text = tweet?.text
            self.updateFavoriteReTweetDetails(tweet: tweet!)
        }
    }
    
    var user : User? {
        didSet{
            fullNameLabel.text = user?.name
            usernameLabel.text = "@\(user?.screenName ?? "noHandle")"
            if let propicURL = user?.profilepic {
                profilePicture.af_setImage(withURL: propicURL)
            }
        }
    }
    
    func updateFavoriteReTweetDetails(tweet: Tweet) {
        if(tweet.favorited == true){
            self.favoriteButton.setImage(UIImage(named: "favor-icon-red.png"), for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(named: "favor-icon.png"), for: .normal)
        }
        self.favoriteButton.setTitle("\(tweet.favoriteCount ?? 0)", for: .normal)
        
        if(tweet.retweeted == true){
            self.retweetButton.setImage(UIImage(named: "retweet-icon-green.png"), for: .normal)
        } else {
            self.retweetButton.setImage(UIImage(named: "retweet-icon.png"), for: .normal)
        }
        self.retweetButton.setTitle("\(tweet.retweetCount ?? 0)", for: .normal)
    }
 
    
    @IBAction func didTapFavorite(_ sender: Any) {
        if (tweet!.favorited == false) {
            APIManager.shared.favorite(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error Favoriting Tweet: \(error.localizedDescription)")
                } else {
                    self.parentView?.getHomeTimeLine()
                }
            }
        }
        else {
            APIManager.shared.unfavorite(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error Favoriting Tweet: \(error.localizedDescription)")
                } else {
                    self.parentView?.getHomeTimeLine()
                }
            }
        }
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if (tweet!.retweeted == false) {
            APIManager.shared.retweet(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error retweeting Tweet: \(error.localizedDescription)")
                } else {
                    self.parentView?.getHomeTimeLine()
                }
            }
        }
        else {
            APIManager.shared.unretweet(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error unretweeting Tweet: \(error.localizedDescription)")
                } else {
                    self.parentView?.getHomeTimeLine()
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
