//
//  LoginViewController.swift
//  twitter
//
//  Created by Neil Shah on 10/10/18.
//  Copyright © 2018 Neil Shah. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        APIManager.shared.login(success: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
}
