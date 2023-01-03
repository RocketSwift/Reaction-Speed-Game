//
//  ViewController.swift
//  Reaction Speed Game
//
//  Created by Denys Zahorskyi on 03.01.2023.
//

import Foundation

class UserDefaultsManager {
    
    private init() {}
    
    static var shared = UserDefaultsManager()
    
    let defaults = UserDefaults.standard
    
        
    func muteSound(_ muteSound: Bool){
        if muteSound == true {
            defaults.set(true, forKey: "IfSoundMuted")
        } else {
            defaults.set(false, forKey: "IfSoundMuted")
        }
    }
    
    func checkSoundPreferences() -> Bool {
        let ifSoundMuted = UserDefaults.standard.bool(forKey: "IfSoundMuted")
        return ifSoundMuted
    }
    
    func retrievePreviousResults() -> [Double] {
        let previousResults = defaults.array(forKey: "GameResults") as? [Double] ?? [Double]()
        return previousResults
    }
    
    func addNewResult(add newResult : [Double]) {
        defaults.set(newResult, forKey: "GameResults")
    }
    
    func saveNewBackground(newBackgroundName: String) {
        UserDefaults.standard.set(newBackgroundName, forKey: "LastSavedBackGround")
    }
    func retrieveLastSavedBackroundName() -> String {
        let lastSavedBackroundName = UserDefaults.standard.string(forKey: "LastSavedBackGround") ?? "1"
        return lastSavedBackroundName
    }

}


