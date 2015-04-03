//
//  CrazyCell2.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class CrazyCell: UITableViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var body: UILabel!
  
  var ride: Ride! {
    didSet { fill() }
  }
  
  func fill() {
    title.text = ride.title
    body.text = ride.body
  }
}
