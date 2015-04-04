//
//  Ride.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import Foundation

struct Ride {
  let id: Int?
  let title: String?
  let body: String?
  
  static func decode(dict: NSDictionary) -> Ride {
    let id = dict.objectForKey("id") as? Int
    let title = dict.objectForKey("title") as? String
    let body = dict.objectForKey("text") as? String
  
    return Ride(id: id, title: title, body: body)
  }
}
