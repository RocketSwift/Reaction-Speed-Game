//
//  MusicManager.swift
//  Reaction Speed Game
//
//  Created by Denys Zahorskyi on 03.01.2023.
//

import Foundation
import AVFoundation

class MusicManager {
    
    private init() {}
    
    static var shared = MusicManager()
    
    var soundMuted: Bool = false
    
    private func playSound(withId id: Int, _ soundMuted: Bool) {
        if soundMuted == false {
            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(id)) {}
        }
        
        
    }
    
    func playStart() {
        self.playSound(withId: 1013, soundMuted)
    }
    
    func playWin() {
        self.playSound(withId: 1025, soundMuted)
    }
    
    func playTick() {
        self.playSound(withId: 1103, soundMuted)
    }
    
    func playOver() {
        self.playSound(withId: 1034, soundMuted)
    }
//
//    func playTock() {
//        self.playSound(withId: 1104)
//    }
//
//    func playVggooh() {
//        self.playSound(withId: 1001)
//    }
//
//    private var bombSoundEffect: AVAudioPlayer?
//
//    func playWoow() {
//        let path = Bundle.main.path(forResource: "wooow.wav", ofType: nil)!
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
//            bombSoundEffect?.play()
//        } catch {
//            // couldn't load file :(
//        }
//    }
    
}
