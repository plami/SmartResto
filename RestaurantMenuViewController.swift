//
//  RestaurantMenuViewController.swift
//  SmartResto
//
//  Created by Galin Yonchev on 11/19/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit

class RestaurantMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum Dishes: String {
        
        case EntryDish = "Entrées"
        case PlatsDish = "Plats"
        case DessertDish = "Desserts Maison"
        case SpecialtyDish = "Formules"
    }
    
    let branch = Manager.sharedInstance.restaurant
    var numberOfRowsAtSection: [Int] = []
    var platsAndPriceDicitonary = [String: String]()
    var entryAndPriceDicitonary = [String: String]()
    var dessertAndPriceDicitonary = [String: String]()
    var emptyAndPriceDicitonary = [String: String]()
    var specialtyAndPriceDicitonary = [String: String]()
    
    typealias dishTuple = (String, String)
    var sortedKeysAndValuesPlats = [dishTuple]()
    var sortedKeysAndValuesEntry = [dishTuple]()
    var sortedKeysAndValuesDessert = [dishTuple]()
    var sortedKeysAndValuesSpecialty = [dishTuple]()
    
    var intArrayPlats: Array<Int?> = []
    var stringArrayPlats: Array<String!> = []
    var platsNames: [String] = []
    var platsPrices: [String] = []
    var entryNames: [String] = []
    var entryPrices: [String] = []
    var dessertNames: [String] = []
    var dessertPrices: [String] = []
    var specialtyNames: [String] = []
    var specialtyPrices: [String] = []
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var buttonReservation: UIButton!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewMenu: UITableView!
    
    // MARK: - Navigation
    
    func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func bookTable(sender: AnyObject) {
        let bookingView: BookingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BookingViewController") as! BookingViewController
        let navigation = UINavigationController(rootViewController: bookingView)
        self.presentViewController(navigation, animated: true, completion: nil)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setupBackground()
        self.imageLogo.setupLogo()
        self.setupButtons()
        self.setUpTitleLabel()
        self.loadData()
        
        self.registerCustomCells()
        self.tableViewMenu.delegate = self
        self.tableViewMenu.dataSource = self
        self.tableViewMenu.allowsSelection = false
        self.tableViewMenu.backgroundColor = UIColor.clearColor()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.activityIndicator.startAnimating()
    }
    
    // MARK: - Networking
    
    //method for loading the menu and sorting by prices in ascending order
    func loadData () {
        
            if self.branch != nil && self.branch?.id != nil {
                SmartRestoClientAPI.sharedInstance.getBranchMenu((branch?.id)!, success: { (menu) -> Void in
                    
                    for var i = 0; i < menu.dishCategory.count; i++ {
                        
                        if menu.dishCategory[i] == Dishes.PlatsDish.rawValue {
                            
                            if menu.dishDescription[i] == "" {
                                
                                    let dish = "\(menu.dishName[i])" + "\n" + "\(menu.dishDescription[i])"
                                    let price = "\(menu.dishPrice[i])"
                                    self.platsAndPriceDicitonary[dish] = price
                                
                            } else {
                                    
                                    let dish = "\(menu.dishName[i])" + "\n" + "(" + "\(menu.dishDescription[i])" + ")"
                                    let price = "\(menu.dishPrice[i])"
                                    self.platsAndPriceDicitonary[dish] = price
                            }
                        }
                        
                        if menu.dishCategory[i] == Dishes.EntryDish.rawValue {
                            
                            if menu.dishDescription[i] == "" {
                                    
                                    let dish = "\(menu.dishName[i])" + "\n" + "\(menu.dishDescription[i])"
                                    let price = "\(menu.dishPrice[i])"
                                    self.entryAndPriceDicitonary[dish] = price
                                
                            } else {
                                    
                                    let dish = "\(menu.dishName[i])" + "\n" + "(" + "\(menu.dishDescription[i])" + ")"
                                    let price = "\(menu.dishPrice[i])"
                                    self.entryAndPriceDicitonary[dish] = price
                            }
                        }
                        
                        if menu.dishCategory[i] == Dishes.DessertDish.rawValue {
                            
                            if menu.dishDescription[i] == "" {
                                    
                                    let dish = "\(menu.dishName[i])" + "\n" + "\(menu.dishDescription[i])"
                                    let price = "\(menu.dishPrice[i])"
                                    self.dessertAndPriceDicitonary[dish] = price
                                
                            } else {
                                    
                                    let dish = "\(menu.dishName[i])" + "\n" + "(" + "\(menu.dishDescription[i])" + ")"
                                    let price = "\(menu.dishPrice[i])"
                                    self.dessertAndPriceDicitonary[dish] = price
                            }
                            
                        }
                        
                        if menu.dishCategory[i] == Dishes.SpecialtyDish.rawValue {
                            
                            if menu.dishDescription[i] == "" {
                                
                                    let dish = "\(menu.dishName[i])" + "\n" + "\(menu.dishDescription[i])"
                                    let price = "\(menu.dishPrice[i])"
                                    self.specialtyAndPriceDicitonary[dish] = price
                                
                            } else {
                                
                                    let dish = "\(menu.dishName[i])" + "\n" + "(" + "\(menu.dishDescription[i])" + ")"
                                    let price = "\(menu.dishPrice[i])"
                                    self.specialtyAndPriceDicitonary[dish] = price
                            }

                        }
                        
                    }
                    
                    //sorting the dishes ascending by their prices in arrays of tuples -> problem in case we have prices like 8 & 12
                    
                    self.sortedKeysAndValuesPlats = self.platsAndPriceDicitonary.sort({ return Int($0.1) > Int($1.1) })
                    print(self.sortedKeysAndValuesPlats)
                    self.platsNames = (self.sortedKeysAndValuesPlats.map {return $0.0})
                    self.platsPrices = (self.sortedKeysAndValuesPlats.map {return $0.1})

                    self.sortedKeysAndValuesEntry = self.entryAndPriceDicitonary.sort({ return Int($0.1) > Int($1.1) })
                    self.entryNames = (self.sortedKeysAndValuesEntry.map {return $0.0})
                    self.entryPrices = (self.sortedKeysAndValuesEntry.map {return $0.1})
                    
                    self.sortedKeysAndValuesDessert = self.dessertAndPriceDicitonary.sort({ return Int($0.1) > Int($1.1) })
                    self.dessertNames = (self.sortedKeysAndValuesDessert.map {return $0.0})
                    self.dessertPrices = (self.sortedKeysAndValuesDessert.map {return $0.1})
                    
                    self.sortedKeysAndValuesSpecialty = self.specialtyAndPriceDicitonary.sort({ return Int($0.1) > Int($1.1) })
                    self.specialtyNames = (self.sortedKeysAndValuesSpecialty.map {return $0.0})
                    self.specialtyPrices = (self.sortedKeysAndValuesSpecialty.map {return $0.1})
                    
                    self.tableViewMenu.reloadData()
                    
                    //array with the number of the dishes in every section of the tableView
                    self.numberOfRowsAtSection = [self.sortedKeysAndValuesSpecialty.count, self.sortedKeysAndValuesEntry.count, self.sortedKeysAndValuesPlats.count,self.sortedKeysAndValuesDessert.count]
                    
                    self.tableViewMenu.reloadData()
      
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
                    }, failure: { (error) -> Void in
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        AlertHelper.showNoInternetError(self)
                })
                }
            }
    
    
    // MARK: - Table View methods
    
    func  numberOfSectionsInTableView (tableView: UITableView ) -> Int {
        
        return Constants.RestaurantMenuViewController.dishesCategories
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows: Int = 0
        
        if section < self.numberOfRowsAtSection.count {
            rows = self.numberOfRowsAtSection[section]
        }
        
        return rows
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?  {
        
        let headerCell: CustomHeaderCell = self.tableViewMenu.dequeueReusableCellWithIdentifier("headerCell")! as! CustomHeaderCell
        headerCell.backgroundColor = UIColor.clearColor()
        
        switch (section) {
           
        case 0:
            headerCell.labelHeader.text = Dishes.SpecialtyDish.rawValue
            //return sectionHeaderView
        case 1:
            headerCell.labelHeader.text = Dishes.EntryDish.rawValue
            //return sectionHeaderView
        case 2:
            headerCell.labelHeader.text = Dishes.PlatsDish.rawValue
            //return sectionHeaderView
        case 3:
            headerCell.labelHeader.text = Dishes.DessertDish.rawValue
            //return sectionHeaderView
        default:
            break
        }
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return Constants.RestaurantMenuViewController.headerHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: DishTableViewCell = self.tableViewMenu.dequeueReusableCellWithIdentifier("dishCell")! as! DishTableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        switch (indexPath.section) {
        
        case 0:
            
            for var i = 0; i < self.specialtyNames.count; i++ {
                cell.labelDishNameAndDescription.text! = self.specialtyNames[indexPath.row]
            }
            for var i = 0; i < self.specialtyPrices.count; i++ {
                
                cell.labelDishPrice.text! = self.specialtyPrices[indexPath.row] + " €"
            }
            
        case 1:
            
            for var i = 0; i < self.entryNames.count; i++ {
                
                cell.labelDishNameAndDescription.text! = self.entryNames[indexPath.row]
            }
            for var i = 0; i < self.entryPrices.count; i++ {
                
                if self.entryPrices[indexPath.row] != "" {
                    
                    cell.labelDishPrice.text! = self.entryPrices[indexPath.row] + " €"
                } else {
                    
                    cell.labelDishPrice.text! = self.entryPrices[indexPath.row]
                }
            }

        case 2:
            
            for var i = 0; i < self.platsNames.count; i++ {
                cell.labelDishNameAndDescription.text! = self.platsNames[indexPath.row]
            }
            for var i = 0; i < self.platsPrices.count; i++ {
                
                if self.platsPrices[indexPath.row] != "" {
                    
                    cell.labelDishPrice.text! = self.platsPrices[indexPath.row] + " €"
                } else {
                    
                    cell.labelDishPrice.text! = self.platsPrices[indexPath.row]
                }
            }
            
        case 3:
            
            for var i = 0; i < self.dessertNames.count; i++ {
                cell.labelDishNameAndDescription.text! = self.dessertNames[indexPath.row]
            }
            for var i = 0; i < self.dessertPrices.count; i++ {
                
                cell.labelDishPrice.text! = self.dessertPrices[indexPath.row] + " €"
            }

        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.RestaurantMenuViewController.rowHeight
    }
    
    // register custom cell
    func registerCustomCells() {
        let nib = UINib(nibName: "DishTableViewCell", bundle: nil)
        tableViewMenu.registerNib(nib, forCellReuseIdentifier: "dishCell")
        
        let nibHeader = UINib(nibName: "CustomHeaderCell", bundle: nil)
        tableViewMenu.registerNib(nibHeader, forCellReuseIdentifier: "headerCell")
    }

    //sorting specialyDishes by length
    func length(value1: String, value2: String) -> Bool {
        // Compare character count of the strings.
        return value1.characters.count < value2.characters.count
    }
    
    // MARK: Controls
    
    func setupButtons() {
        buttonReservation.setTitle(NSLocalizedString("menu.booking", comment: ""), forState: UIControlState.Normal)
        buttonReservation.layer.cornerRadius = 0.1 * buttonReservation.bounds.size.width
        // setup navigation close button
        let closeImage = UIImage(named: "icon_close")
        let closeButton = UIButton(type: UIButtonType.Custom)
        closeButton.frame = CGRectMake(0, 0, 30, 30)
        closeButton.setBackgroundImage(closeImage, forState: .Normal)
        closeButton.addTarget(self, action: "goBack:", forControlEvents: .TouchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        self.navigationItem.setRightBarButtonItem(closeBarButton, animated: false)
    }
    
    func setUpTitleLabel() {
        if Manager.sharedInstance.restaurantName == Constants.RestaurantsNames.CaveGaribaldiRestaurant {
            self.labelHeading.text = Constants.RestaurantsNames.CaveGaribaldiRestaurant
        } else {
            self.labelHeading.text = Constants.RestaurantsNames.CommuneImageRestaurant
        }
    }
}
