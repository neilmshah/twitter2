//
//  TimelineViewController.swift
//  twitter
//
//  Created by Neil Shah on 10/10/18.
//  Copyright © 2018 Neil Shah. All rights reserved.
//


import UIKit
import MBProgressHUD

class TimelineViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.getHomeTimeLine), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        self.updateUserInformation()
        self.getHomeTimeLine()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update User
    func updateUserInformation() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIManager.shared.getCurrentAccount { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            if let user = user {
                User.current = user
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    // Network Request
    func getHomeTimeLine() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let error = error {
                print(error.localizedDescription)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            else {
                self.tweets = tweets!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    @IBAction func didTapProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfileSegue", sender: nil)
    }
    
    @IBAction func didTapCompost(_ sender: Any) {
        self.performSegue(withIdentifier: "composeTimelineSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.user = tweet.user
        cell.parentView = self as TimelineViewController
        cell.indexPath = indexPath
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.getHomeTimeLine()
        if (segue.identifier == "detailSegue") {
            if let detailView = segue.destination as? tweetDetailViewController {
                if let cell = sender as! TweetCell? {
                    detailView.tweet = tweets[(cell.indexPath?.row)!]
                }
            }
        }
        if (segue.identifier == "ProfileSegue") {
            if let profileView = segue.destination as? ProfileViewController {
                profileView.user = User.current
            }
        }
        if(segue.identifier == "composeTimelineSegue") {
            if let composeView = segue.destination as? composeViewController {
                composeView.user = User.current
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
