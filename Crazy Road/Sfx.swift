//
//  Sfx.swift
//  Simon Says
//
//  Created by Maher, Matt on 2/21/21.
//

import AVFoundation

class Sfx: NSObject {
  let gsa = GSAudio.sharedInstance

  func playHorn() {
    gsa.playSound(soundFileName: "horn", ofType: "mp3")
  }
  
  func stopAll() {
    
  }
  
}
