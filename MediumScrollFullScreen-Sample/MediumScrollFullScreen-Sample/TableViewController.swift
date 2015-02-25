//
//  TableViewController.swift
//  MediumScrollFullScreen-Sample
//
//  Created by pixyzehn on 2/24/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let array = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity", "Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity"]
    
    let textCellIdentifier = "TextCell"
    
    override func viewWillLayoutSubviews() {
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let icon: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "medium_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu")
        icon.imageInsets = UIEdgeInsetsMake(-10, 0, 0, 0)
        icon.tintColor = UIColor.blackColor()
        navigationItem.leftBarButtonItem = icon
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showMenu() {
        println("Show Menu!")
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
