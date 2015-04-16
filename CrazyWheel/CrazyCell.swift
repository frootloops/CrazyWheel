//
//  CrazyCell2.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class CrazyCell: UITableViewCell {
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var body: UILabel?
    
    var ride: Ride? {
        didSet {
            configureView()
        }
    }
    
    private func configureView() {
        if let currentRide = ride {
            title?.text = currentRide.title
            body?.text = currentRide.body
        }
    }
}
