//
//  composeViewController.swift
//  twitter
//
//  Created by Neil Shah on 10/19/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class composeViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    var user: User?
    var characterLimit : Int = 141
    var isReply: Bool = false
    var replyName: String?
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.isEnabled = false
        tweetTextView.textColor = UIColor.lightGray
        tweetTextView.delegate = self as UITextViewDelegate
        loadProfileInfo()
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        APIManager.shared.updateTweetCount(user: User.current)
        self.performSegue(withIdentifier: "returnSegue", sender: nil)
    }
    
    @IBAction func onTapPost(_ sender: Any) {
        let tweetText = tweetTextView.text!
        APIManager.shared.composeTweet(with: tweetText) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
            }
        }
        self.performSegue(withIdentifier: "ReturnSegue", sender: nil)
    }
    
    @IBAction func onTapOutside(_ sender: Any) {
        view.endEditing(true)
    }
    func loadProfileInfo(){
        if let user = self.user {
            usernameLabel.text = "@\(user.screenName)"
            if user.name != nil {
                fullNameLabel.text = user.name
            }
            if let profilepicURL = user.profilepic {
                profilePicImageView.af_setImage(withURL: profilepicURL)
            }
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor == UIColor.lightGray) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text.count == 0) {
            textView.text = "Write a post..."
            textView.textColor = UIColor.lightGray
            postButton.isEnabled = false
        }
    }
    
    //Character count
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        let current = newText.count
        characterCountLabel.text = "Character Count: \(current)"
        if (current == 0) {
            postButton.isEnabled = false
            return true;
        }
        postButton.isEnabled = true
        if (current < characterLimit) {
            characterCountLabel.textColor = UIColor.lightGray
            return true
        } else {
            characterCountLabel.textColor = UIColor.red
            if (current == characterLimit) {
                characterCountLabel.text = "Character Count: 140"
            }
            return false
        }
    }

}

protocol ComposeViewControllerDelegate : class {
    func did(post : Tweet)
}
