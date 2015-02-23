//
//  TableViewController.swift
//  MediumScrollFullScreen
//
//  Created by pixyzehn on 2/16/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let array = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity", "Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity"]
    
    let textCellIdentifier = "TextCell"
    
    override func viewWillLayoutSubviews() {
        navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        navigationController?.toolbar.backgroundColor = UIColor.whiteColor()
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        
        var icon: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "medium_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu")
        icon.imageInsets = UIEdgeInsetsMake(-10, 0, 0, 0)
        icon.tintColor = UIColor.blackColor()
        navigationItem.leftBarButtonItem = icon
        
        //var backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: UIBarButtonItemStyle.Plain, target: self, action: "")
        
        //backButton.setBackgroundImage(UIImage(named: "arrow"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        //backButton.title = ""
        
        //let view = UIImageView(image: UIImage(named: "arrow")) as UIView
        
//        navigationItem.hidesBackButton = true
//        navigationItem.title = ""
//        UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(named: "arrow"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        //var backButton = UIBarButtonItem(customView: view)
        
        //navigationItem.setHidesBackButton(true, animated: false)
        //navigationItem.backBarButtonItem = backButton
        
        
//        var customButton = UIButton()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showMenu() {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
   override  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")

        let row = indexPath.row
        cell.textLabel?.text = array[row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        performSegueWithIdentifier("show",sender: nil)
    }
    
}
