//
//  MasterViewController.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit
import AVFoundation

class MasterViewController: UITableViewController {

  var objects = [Ride]()


  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func refresh(sender: UIRefreshControl) {
    sender.endRefreshing()
  }

  // MARK: - Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
        if let indexPath = self.tableView.indexPathForSelectedRow() {
  //          let object = objects[indexPath.row] as NSDate
//        (segue.destinationViewController as DetailViewController).detailItem = object
        }
    }
  }

  // MARK: - Table View

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

//    let object = objects[indexPath.row] as NSDate
//    cell.textLabel!.text = object.description
    return cell
  }
  
  // MARK: - UI
  
  func customizeNavigationBar() {
    if let nav = self.navigationController?.navigationBar {
      nav.barStyle = UIBarStyle.Black
      nav.barTintColor = UIColor.blackColor()
      nav.tintColor = UIColor.whiteColor()
    }
  }
}

