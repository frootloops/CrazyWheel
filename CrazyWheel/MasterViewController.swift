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
  let app = UIApplication.sharedApplication()
  let worker = Worker()
  var rides = [Ride]()


  override func viewDidLoad() {
    super.viewDidLoad()
    customizeNavigationBar()
    startUpdating(){}
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100.0
  }
  
  @IBAction func refresh(sender: UIRefreshControl) {
    startUpdating() {
      sender.endRefreshing()
    }
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

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rides.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as CrazyCell
    cell.ride = rides[indexPath.row] as Ride
    
    return cell
  }
  
  func startUpdating(finish: () -> Void) {
    app.networkActivityIndicatorVisible = true
    
    worker.update({ (rides) -> Void in
      self.app.networkActivityIndicatorVisible = false
      self.rides = rides
      dispatch_async(dispatch_get_main_queue(), {
        self.tableView.reloadData()
      })
      finish()
    }, failure: { (error) -> Void in
      self.app.networkActivityIndicatorVisible = false
      finish()
      println("Damn!")
    })
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

