//
//  LoginViewController.swift
//  Twitter
//
//  Created by Adam Ding on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "loggedin") == true {
            self.performSegue(withIdentifier: "logintohome", sender: self)
        }
    }   //if user has logged in before, without logging out, skips login screen and goes straight to home screen
    
    @IBAction func loginClicked(_ sender: Any) {
        print("login has been clicked")
        let myUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: myUrl, success: {
            
            UserDefaults.standard.set(true, forKey: "loggedin")
            self.performSegue(withIdentifier: "logintohome", sender: self)
            
        }, failure: { (Error) in
            print("Login failed")
        })
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
