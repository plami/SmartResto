//
//  HelpViewController.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 1/11/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIWebViewDelegate  {

    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelHelpTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setupBackground()
        self.imageLogo.setupLogo()
        self.setupNavigationBar()
        self.setupButtons()
        self.loadData()
        
        webView.delegate = self
        
    }
    
    // webView methods
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        AlertHelper.showServerError(self)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
    }
    
    // MARK: - Networking
    
    func loadData () {
        
        let urlPath = NSLocalizedString("urlHelp", comment: "")
        let requestUrl = NSURL(string: urlPath)
        let request = NSURLRequest(URL: requestUrl!)
        webView.loadRequest(request)
        webView.scrollView.bounces = false
        webView.opaque = false
        webView.backgroundColor = UIColor.clearColor()
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
        
        self.labelHelpTitle.text = NSLocalizedString("userAccount.help", comment: "")
        
    }

    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    func goBack(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
