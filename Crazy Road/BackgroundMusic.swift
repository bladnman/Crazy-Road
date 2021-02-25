//
//  BackgroundMusic.swift
//  Crazy Road
//
//  Created by Maher, Matt on 2/24/21.
//

import AVFoundation

var player: AVAudioPlayer?

class BackgroundMusic {
  func play() {
    
    // already playing
    if (player != nil) && player!.isPlaying {
      return
    }
    
    guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else { return }

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

      /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

      /* iOS 10 and earlier require the following line:
       player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

      guard let player = player else { return }
      
      player.numberOfLoops = -1 // repeat

      player.play()

    } catch {
      print(error.localizedDescription)
    }
  }

  func stop() {
    guard let player = player else { return }
    player.stop()
  }
}
