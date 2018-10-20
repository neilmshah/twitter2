//
//  Tweet.swift
//  twitter
//
//  Created by Neil Shah on 10/10/18.
//  Copyright © 2018 Neil Shah. All rights reserved.
//


import Foundation
import DateToolsSwift

class Tweet {
    
    // MARK: Properties
    var id: Int64? // For favoriting, retweeting & replying
    var text: String // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int? // Update favorite count label
    var retweeted: Bool? // Configure retweet button
    var user: User // Author of the Tweet
    var createdAtString: String? // String representation of date posted
    
    // For Retweets
    var retweetedByUser: User?  // user who retweeted if tweet is retweet
    
    init(dictionary: [String: Any]) {
        var dictionary = dictionary
        
        if let originalTweet = dictionary["retweeted_status"] as? [String: Any] {
            let userDictionary = dictionary["user"] as! [String: Any]
            self.retweetedByUser = User(dictionary: userDictionary)
            
            //Change tweet to original tweet
            dictionary = originalTweet
        }
        
        if let twitid: NSNumber = dictionary["id"] as? NSNumber{
            id = twitid.int64Value
        }
        
        text = dictionary["text"] as! String
        favoriteCount = dictionary["favorite_count"] as? Int ?? 0
        favorited = dictionary["favorited"] as? Bool ?? false
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        retweeted = dictionary["retweeted"] as? Bool ?? false
        
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        // Format createdAt date string
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        createdAtString = date.shortTimeAgoSinceNow
    }
    
    static func tweets(with array: [[String: Any]]) -> [Tweet] {
        var tweets: [Tweet] = []
        for tweetDictionary in array {
            let tweet = Tweet(dictionary: tweetDictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
