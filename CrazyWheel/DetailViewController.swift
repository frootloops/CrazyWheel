//
//  DetailViewController.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var name: UILabel?
  @IBOutlet weak var text: UILabel?
    
    var ride: Ride? {
        didSet {
            configureView()
        }
    }

  func configureView() {
    if let currentRide = ride {
        name?.text = currentRide.title
        text?.text = currentRide.body
        navigationItem.title = currentRide.title
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
}

