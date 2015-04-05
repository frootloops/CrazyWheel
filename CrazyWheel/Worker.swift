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
  
  init() {
    session.configuration.timeoutIntervalForRequest = 10
  }

  private struct Constants {
    static let host = "http://crazy-dev.wheely.com"
  }
  
  func update(success: (( rides: [Ride]! ) -> Void), failure: (( error: NSError? ) -> Void))
  {
    if inProgress { return }
    inProgress = true

    session.dataTaskWithURL(NSURL(string: Constants.host)!) {(data, response, error) in
      if error != nil {
        failure(error: error)
        self.inProgress = false
      }
      
      if let data = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [NSDictionary] {
        self.inProgress = false
        success(rides: data.map { Ride.decode($0) }.filter { $0.valid() })
      }
    }.resume()
  }
}