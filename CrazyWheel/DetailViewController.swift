//
//  DetailViewController.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 03/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  var ride: Ride?
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var text: UILabel!

  func configureView() {
    name.text = ride?.title
    text.text = ride?.body
    navigationItem.title = ride?.title
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
}

