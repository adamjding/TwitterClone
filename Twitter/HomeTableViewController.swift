//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Adam Ding on 1/30/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    
    
    
    @objc func loadTweets(){
        numberOfTweets = 20
        let myurl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParems = ["count" : numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myurl, parameters: myParems, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()  //clears array
            for tweet in tweets{
                self.tweetArray.append(tweet)   //populates the array
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retreive tweets")
        })
    }
    
    func loadMoreTweets(){
        let myurl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myParems = ["count" : numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myurl, parameters: myParems, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()  //clears array
            for tweet in tweets{
                self.tweetArray.append(tweet)   //populates the array
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retreive tweets")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

    @IBAction func logoutPressed(_ sender: Any) {
        TwitterAPICaller.client?.logout()   //logout for user
        self.dismiss(animated: true, completion: nil)   //dismisses screen
        UserDefaults.standard.set(false, forKey: "loggedin")    //if user logouts set the UserDefaults to false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetcell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.nameLabel.text = user["name"] as! String as! String
        cell.tweetLabel.text = tweetArray[indexPath.row]["text"] as! String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImage.image = UIImage(data : imageData)
        }
        
        cell.setFavorite(isFavorited: tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        return cell
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
}
