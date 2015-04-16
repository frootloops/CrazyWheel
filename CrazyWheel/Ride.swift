//
//  Ride.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import Foundation

struct Ride {
  let id: Int
  let title: String
  let body: String
  
  static func decode(data: NSDictionary) -> Ride? {
    if let id = data["id"] as? Int,
        title = data["title"] as? String,
         body = data["text"] as? String {
          return Ride(id: id, title: title, body: body)
    }

    return .None
  }
}
