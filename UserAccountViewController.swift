//
//  UserAccountViewController.swift
//  SmartResto
//
//  Created by Galin Yonchev on 11/19/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit

class UserAccountViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var profileTableView: UITableView!
    var items: [String] = [NSLocalizedString("userAccount.home", comment: ""), NSLocalizedString("userAccount.profile", comment: ""), NSLocalizedString("userAccount.help", comment: ""), NSLocalizedString("userAccount.legalNotice", comment: "")]
    var itemsImages: [String] = ["icon_right_menu_first", "icon_right_menu_second","icon_right_menu_third","icon_right_menu_fourth"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        self.profileTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.profileTableView.backgroundColor = UIColor.clearColor()
        self.registerCustomCell()
        
    }

    // MARK: - Navigation
    
    
    // MARK: - Table View methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ProfileTableViewCell = self.profileTableView.dequeueReusableCellWithIdentifier("profileCell")! as! ProfileTableViewCell
        cell.backgroundColor = UIColor.blackColor()
        cell.profileLabel.text = items[indexPath.row]
        cell.profileImage.image = UIImage(named: itemsImages[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            
            let homeView : RestaurantsViewController = self.storyboard?.instantiateViewControllerWithIdentifier ("RestaurantsViewController") as! RestaurantsViewController
            let navigation = UINavigationController(rootViewController: homeView)
            let rvc:SWRevealViewController = self.revealViewController() as SWRevealViewController
            rvc.pushFrontViewController(navigation, animated: true)
        }
        
        if indexPath.row == 1 {
            
            let myAccountView = self.storyboard?.instantiateViewControllerWithIdentifier("MyAccountViewController") as! MyAccountViewController
            let navigation = UINavigationController(rootViewController: myAccountView)
            self.presentViewController(navigation, animated: true, completion: nil)
            
            //the main runloop is awaken, because it has been asleep -> which is causing the view to be opened on 2nd tap on the tableViewCell
            CFRunLoopWakeUp(CFRunLoopGetCurrent());
        }
        
        if indexPath.row == 2 {
            let helpView = self.storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as! HelpViewController
            let navigation = UINavigationController(rootViewController: helpView)
            self.presentViewController(navigation, animated: true, completion: nil)
            CFRunLoopWakeUp(CFRunLoopGetCurrent());
        }
        
        if indexPath.row == 3 {
            let legalNoticeView = self.storyboard?.instantiateViewControllerWithIdentifier("LegalNoticeViewController") as! LegalNoticeViewController
            let navigation = UINavigationController(rootViewController: legalNoticeView)
            self.presentViewController(navigation, animated: true, completion: nil)
            CFRunLoopWakeUp(CFRunLoopGetCurrent());
        }
        
        print("You selected cell #\(indexPath.row)!")
    }
    
    // register custom cell
    func registerCustomCell() {
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        profileTableView.registerNib(nib, forCellReuseIdentifier: "profileCell")
    }
}
