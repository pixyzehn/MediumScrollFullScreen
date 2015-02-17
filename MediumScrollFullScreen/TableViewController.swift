//
//  TableViewController.swift
//  MediumScrollFullScreen
//
//  Created by pixyzehn on 2/16/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let blogs = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity"]
    
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
   override  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")

        let row = indexPath.row
        cell.textLabel?.text = blogs[row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        performSegueWithIdentifier("show",sender: nil)
    }
    
}
