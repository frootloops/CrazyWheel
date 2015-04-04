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
  let soundEffect = SoundEffect()
  var timer: NSTimer?
  var rides = [Ride]()


  override func viewDidLoad() {
    super.viewDidLoad()
    customizeUI()
    refreshControl?.beginRefreshing()
    startUpdating() {
      self.refreshControl?.endRefreshing()
      return
    }
  }
  
  @IBAction func refresh(sender: UIRefreshControl) {
    startUpdating() {
      sender.endRefreshing()
      self.soundEffect.play()
    }
  }
  
  override func viewDidDisappear(animated: Bool) {
    timer?.invalidate()
    timer = nil
  }
  
  override func viewDidAppear(animated: Bool) {
    timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: Selector("tickTock"), userInfo: nil, repeats: true)
  }
  
  func tickTock() {
    startUpdating()
  }

  // MARK: - Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let indexPath = self.tableView.indexPathForSelectedRow() {
      let ride = rides[indexPath.row] as Ride
      (segue.destinationViewController as DetailViewController).ride = ride
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
  
  func startUpdating(finish: (() -> Void)? = nil) {
    app.networkActivityIndicatorVisible = true
    
    worker.update({ (rides) -> Void in
      dispatch_async(dispatch_get_main_queue(), {
        finish?()
        self.app.networkActivityIndicatorVisible = false
        self.rides = rides
        self.tableView.reloadData()
      })
    }, failure: { (error) -> Void in
      dispatch_async(dispatch_get_main_queue(), {
        self.app.networkActivityIndicatorVisible = false
        finish?()
        println("Damn!")
      })
    })
  }
  
  // MARK: - UI
  
  func customizeUI() {
    if let nav = self.navigationController?.navigationBar {
      nav.barStyle = UIBarStyle.Black
      nav.barTintColor = UIColor.blackColor()
      nav.tintColor = UIColor.whiteColor()
    }
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100.0
    clearsSelectionOnViewWillAppear = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
  }
}

