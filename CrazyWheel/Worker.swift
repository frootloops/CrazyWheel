//
//  Worker.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class Worker {
  let session = NSURLSession.sharedSession()
  var inProgress = false

  private struct Constants {
    static let host = "http://crazy-dev.wheely.com"
  }
  
  func update(success: (( rides: [Ride]! ) -> Void), failure: (( error: NSError? ) -> Void))
  {
    if inProgress {
      return
    } else {
      inProgress = true
    }

    let task = session.dataTaskWithURL(NSURL(string: Constants.host)!) {(data, response, error) in
      if let collection = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? [NSDictionary] {
        self.inProgress = false
        if error != nil {
          failure(error: error)
        } else {
          success(rides: collection.map { Ride.decode($0) })
        }
      }
    }
    task.resume()
  }
}