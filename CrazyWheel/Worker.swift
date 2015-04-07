//
//  Worker.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class Worker {
  private let session = NSURLSession.sharedSession()
  private (set) var inProgress = false
  
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
      let httpResponse = response as? NSHTTPURLResponse
      
      if error != nil || httpResponse?.statusCode != 200 {
        failure(error: error)
        self.inProgress = false
      }
      
      if let data = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [NSDictionary] {
        self.inProgress = false
        let rides = data.map { Ride.decode($0) }.filter { $0 != nil }.map { $0! }
        success(rides: rides)
      }
    }.resume()
  }
}