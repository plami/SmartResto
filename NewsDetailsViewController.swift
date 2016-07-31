//
//  NewsDetailsViewController.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 2/2/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import UIKit
import Haneke
import Kingfisher

class NewsDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelNews: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textViewNews: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newsDetails: News?
    var newsBackgroundcolor: UIColor?
    var newsPhoto: UIImage?
    let branch = Manager.sharedInstance.restaurant
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup UI
        self.view.setupBackground()
        self.imageLogo.setupLogo()
        self.setupButtons()
        self.loadData()
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.getNewsImage()
        
        //the main runloop is awaken, because it has been asleep -> which is causing the view to be opened on 2nd tap on the tableViewCell
         (CFRunLoopGetCurrent());
    }
    
    override func viewDidAppear(animated: Bool) {
        self.activityIndicator.startAnimating()
    }
    
    // MARK: - Navigation
    
    func goBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - Networking
    
    func loadData () {
        self.textViewNews.text = newsDetails!.content
        self.labelNews.text = newsDetails!.title
        self.labelDate.text = newsDetails!.date
        self.labelDate.backgroundColor = newsBackgroundcolor
    }

    //method for caching the photo of every neews -> Kingfisher framework
    func getNewsImage () {
        
        if newsDetails!.photoURL != nil {
            
            let cache = KingfisherManager.sharedManager.cache
            let URL = String(format: "http://admin.smartresto.fr/download?blobkey=%@", newsDetails!.photoURL!)
            let url = NSURL(string: URL)
            let key = String(format: "newsImage %@", newsDetails!.title!)
            
            self.imageNews.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil,
                progressBlock: { receivedSize, totalSize in
                    cache.retrieveImageInDiskCacheForKey(key)
                },
                completionHandler: { image, error, cacheType, imageURL in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
            })
            
//            let cache = Shared.dataCache
//            let newsImageURL = String(format: "http://admin.smartresto.fr/download?blobkey=%@", newsDetails!.photoURL!)
//            let url = NSURL(string: newsImageURL)
//            let imageData = NSData(contentsOfURL: url!)
//            let key = String(format: "newsImage %@", newsDetails!.title!)
//            
//            //loading the image on first start of the application
//            self.imageNews.image = UIImage(data: imageData!)
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.hidden = true
//            
//
//            // if there are no images cached, save them in the cache
//            // display them
//            cache.fetch(key: key).onFailure { (error) -> () in
//                cache.set(value: imageData!, key: key)
//            }
//            // if there are images cached, then just display them
//            cache.fetch(key: key).onSuccess { (data) -> () in
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.hidden = true
//                let image = UIImage(data: data)
//                self.imageNews.image = image
//            }
            
        } else {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
        }
    }
    
    // MARK: - Controls
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



