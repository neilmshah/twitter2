//
//  User.swift
//  twitter
//
//  Created by Neil Shah on 10/10/18.
//  Copyright © 2018 Neil Shah. All rights reserved.
//


import Foundation

class User {
    
    var screenName: String
    var name: String?
    var profilepic: URL?
    var bannerpic: URL?
    var friendcount: Int?
    var followercount : Int?
    var userid: Int64?
    var favoritecount: Int?
    var statusCount : Int?
    
    //static var current: User?
    var dictionary: [String: Any]?
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as! String
        friendcount = dictionary["friends_count"] as? Int ?? 0
        followercount = dictionary["followers_count"] as? Int ?? 0
        statusCount = dictionary["statuses_count"] as? Int ?? 0
        favoritecount = dictionary["favourites_count"] as? Int ?? 0
        
        guard let twitterID: NSNumber = dictionary["id"] as? NSNumber else {
            print("Twitter ID Error")
            return
        }
        userid = twitterID.int64Value
        
        if let profile: String = dictionary["profile_image_url_https"] as? String {
            profilepic = URL(string: profile)!
        }
        
        if let banner : String = dictionary["profile_banner_url"] as? String {
            bannerpic = URL(string: banner)!
        }
    }
    
    private static var _current: User?
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
}
