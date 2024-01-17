//
//  AudioManager.swift
//  DictHome
//
//  Created by Kholmumin Tursinboev on 17/01/24.
//
import Foundation
import AVFoundation

class AudioPlayer {
    var player: AVPlayer?
    func playAudio(from url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            player = AVPlayer(url: url)
            player?.play()
        } catch {
            print("Failed to initialize or play audio. Error: \(error)")
        }
    }
}
