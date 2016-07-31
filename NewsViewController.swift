//
//  NewsViewController.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 11/18/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit
import Haneke
import Alamofire

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelNews: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let branch = Manager.sharedInstance.restaurant
    var news: [News] = []
    var newsImage: UIImageView?
    
    // MARK: - Navigation
    
    func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup UI
        self.view.setupBackground()
        self.imageLogo.setupLogo()
        self.setupLabels()
        self.setupButtons()
        //
        self.loadData()
        self.registerCustomCell()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.allowsSelection = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //the main runloop is awaken, because it has been asleep -> which is causing the view to be opened on 2nd tap on the tableViewCell
        CFRunLoopWakeUp(CFRunLoopGetCurrent());
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.activityIndicator.startAnimating()
    }
    
    //MARK: - Networking
    
    func loadData () {
        //first load all the news locally
        if Manager.sharedInstance.restaurantName == Constants.RestaurantsNames.CaveGaribaldiRestaurant {
            self.news = SmartRestoClientAPI.sharedInstance.readLocalNews("LaCaveGaribaldi")
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            self.tableView.reloadData()
        } else if Manager.sharedInstance.restaurantName == Constants.RestaurantsNames.CommuneImageRestaurant {
            self.news = SmartRestoClientAPI.sharedInstance.readLocalNews("CommuneImage")
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            self.tableView.reloadData()
        }
        //in case of update, refresh it
        if branch != nil && branch?.id != nil {
            SmartRestoClientAPI.sharedInstance.getBranchNews(branch!.id!, success: { (news) -> Void in
                self.news = news
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                }) { (error) -> Void in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    AlertHelper.showNoInternetError(self)
            }
        }
    }
    
    // MARK: - Controls

    func setupLabels() {
        labelNews.text = NSLocalizedString("news.heading", comment: "")
    }
    
    func setupButtons() {
        // setup navigation close button
        let closeImage = UIImage(named: "icon_close")
        let closeButton = UIButton(type: UIButtonType.Custom)
        closeButton.frame = CGRectMake(0, 0, 30, 30)
        closeButton.setBackgroundImage(closeImage, forState: .Normal)
        closeButton.addTarget(self, action: "goBack:", forControlEvents: .TouchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        self.navigationItem.setRightBarButtonItem(closeBarButton, animated: false)
    }
    
    // MARK: - Table View methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("newsCell")! as! NewsTableViewCell
        let news = self.news[indexPath.row]
        cell.loadData(self.colorRow(indexPath.row), news: news)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //the main runloop is awaken, because it has been asleep -> which is causing the view to be opened on 2nd tap on the tableViewCell
        CFRunLoopWakeUp(CFRunLoopGetCurrent());
        
        let news = self.news[indexPath.row]
 
        let backgroundColor = self.colorRow(indexPath.row)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let newsView : NewsDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier ("NewsDetailsViewController") as! NewsDetailsViewController
            
            newsView.newsDetails = news
            newsView.newsBackgroundcolor = backgroundColor
            self.navigationController?.pushViewController(newsView, animated: true)
        })
    }
    

    // register custom cell
    func registerCustomCell() {
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "newsCell")
    }
    
    func colorRow(row: Int) -> UIColor {
        if row % 3 == 0 {
            return UIColor.SRRed
        }
        if row % 3 == 1 {
            return UIColor.SRGreen
        }
        if row % 3 == 2 {
            return UIColor.SRGray
        }
        return UIColor.SRRed
    }
}
