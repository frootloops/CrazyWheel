//
//  Worker.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class Worker : NSObject {
    internal (set) var willUpdate: (() -> Void)?
    internal (set) var didUpdate: (() -> Void)?
    internal (set) var onSuccess:  (() -> Void)?
    internal (set) var onFailure: (( error: NSError? ) -> Void)?
    
    private var timer: NSTimer?
    private (set) var rides = [Ride]()
    private (set) var inProgress = false {
        willSet {
            if newValue == true {   
                willUpdate?()
            } else {
                didUpdate?()
                dispatch_async(dispatch_get_main_queue(), {
                    self.stop()
                    self.start()
                })
            }
        }
    }
    
    internal func update()
    {
        if inProgress {
            failure(error: NSError(domain: "Worker is busy", code: 501, userInfo: nil))
        } else {
            inProgress = true
            get()
        }
    }
    
    internal func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    
    ////////////////////////////////////////////////////////////////////////////
    

    private func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(42,
            target: self, selector: "update", userInfo: nil, repeats: false)
    }
    
    private func get() {
        let session = NSURLSession.sharedSession(),
            url = NSURL(string: "http://crazy-dev.wheely.com/")!
        session.configuration.timeoutIntervalForRequest = 10
        
        session.dataTaskWithURL(url) {(data, response, error) in
            let httpResponse = response as? NSHTTPURLResponse
            
            if error != nil || httpResponse?.statusCode != 200 {
                self.failure(error: error)
            } else {
                self.parse(data)
            }
        }.resume()
    }
    
    private func parse(data: NSData) {
        var parseError: NSError?

        if let data = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError) as? [NSDictionary] {
            if parseError != nil {
                self.failure(error: parseError)
            } else {
                self.rides = data.map { Ride.decode($0) }.filter { $0 != nil }.map { $0! }
                self.success()
            }
        } else {
            self.failure(error: NSError(domain: "Network", code: 500, userInfo: nil))
        }
    }
    
    private func failure(#error: NSError?) {
        onFailure?(error: error)
        inProgress = false
    }
    
    private func success() {
        onSuccess?()
        inProgress = false
    }
}