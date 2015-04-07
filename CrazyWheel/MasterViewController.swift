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
  // MARK: - variables
  private let app = UIApplication.sharedApplication()
  private let worker = Worker()
  private let dingSoundEffect = DingSoundEffect()
  private var timer: NSTimer?
  private var rides = [Ride]()
  private typealias VoidFunc = () -> Void


  override func viewDidLoad() {
    super.viewDidLoad()
    customizeUI()
    refreshControl!.beginRefreshing()
    startUpdating() {
      self.refreshControl!.endRefreshing()
    }
  }
  
  @IBAction func refresh(sender: UIRefreshControl) {
    startUpdating() {
      sender.endRefreshing()
      self.dingSoundEffect.play()
    }
  }
  
  override func viewDidDisappear(animated: Bool) {
    timer?.invalidate()
  }
  
  override func viewDidAppear(animated: Bool) {
    startBgRefreshing()
  }
  
  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
    if motion == .MotionShake {
      refreshControl!.beginRefreshing()
      refresh(refreshControl!)
    }
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
  
  // MARK: - Updates
  
  func bgRefresh() {
    timer?.invalidate()
    startUpdating() {
      self.startBgRefreshing()
    }
  }
  
  private func startUpdating(finish: VoidFunc) {
    app.networkActivityIndicatorVisible = true
    
    worker.update({ (rides) -> Void in
      dispatch_async(dispatch_get_main_queue(), {
        finish()
        self.app.networkActivityIndicatorVisible = false
        self.rides = rides
        self.tableView.reloadData()
      })
    }, failure: { (error) -> Void in
      dispatch_async(dispatch_get_main_queue(), {
        finish()
        self.app.networkActivityIndicatorVisible = false
      })
    })
  }
  
  private func startBgRefreshing() {
    timer = NSTimer.scheduledTimerWithTimeInterval(42,
      target: self,
      selector: Selector("bgRefresh"),
      userInfo: nil,
      repeats: true)
  }
  
  // MARK: - UI
  
  private func customizeUI() {
    if let nav = self.navigationController?.navigationBar {
      nav.barStyle = .Black
      nav.barTintColor = .blackColor()
      nav.tintColor = .whiteColor()
    }
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100.0
    clearsSelectionOnViewWillAppear = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
  }
}

