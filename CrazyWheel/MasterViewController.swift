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
    private let worker = Worker()
    private let dingSoundEffect = DingSoundEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureWorker()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        worker.stop()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        worker.update()
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        worker.update()
    }
    
    // MARK: - UI
    
    private func configureView() {
        if let nav = self.navigationController?.navigationBar {
            nav.barStyle = .Black
            nav.barTintColor = .blackColor()
            nav.tintColor = .whiteColor()
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        clearsSelectionOnViewWillAppear = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        navigationItem.titleView = UIImageView(image: UIImage(named:"Logo")!)

    }
    
    // MARK - Worker
    
    private func configureWorker() {
        worker.willUpdate = { [weak self] in
            dispatch_async(dispatch_get_main_queue(), {
                self?.navigationItem.prompt = nil
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            })
        }
        
        worker.didUpdate = { [weak self] in
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self?.refreshControl?.endRefreshing()
            })
        }
        
        worker.onSuccess = { [weak self] in
            dispatch_async(dispatch_get_main_queue(), {
                self?.dingSoundEffect.play()
                self?.tableView.reloadData()
            })
        }
        
        worker.onFailure = { [weak self] ( error: NSError? ) in
            dispatch_async(dispatch_get_main_queue(), {
                self?.navigationItem.prompt = error?.domain
            })
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let ride = worker.rides[indexPath.row] as Ride
            (segue.destinationViewController as! DetailViewController).ride = ride
        }
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worker.rides.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CrazyCell
        cell.ride = worker.rides[indexPath.row] as Ride
        
        return cell
    }
}

