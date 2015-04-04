//
//  SoundEffect.swift
//  CrazyWheel
//
//  Created by Arsen Gasparyan on 04/04/15.
//  Copyright (c) 2015 Arsen Gasparyan. All rights reserved.
//

import Foundation
import AVFoundation

class SoundEffect {
  let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ding", ofType: "aif")!)
  var audioPlayer = AVAudioPlayer()
  
  init() {
    audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: nil)
    audioPlayer.prepareToPlay()
  }
  
  func play() {
    audioPlayer.play()
  }
}