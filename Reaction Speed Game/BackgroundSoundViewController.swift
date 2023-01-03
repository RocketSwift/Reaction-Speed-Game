//
//  BackgroundSoundViewController.swift
//  Reaction Speed Game
//
//  Created by Denys Zahorskyi on 03.01.2023.
//

import UIKit

class BackgroundSoundViewController: UIViewController {
    
    let soundButton = UIButton()
    let backToMenuButton = UIButton()
    
    var soundMuted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMuteSoundButton()
        createBackToMenuButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSoundStatus(_:)), name: NSNotification.Name(rawValue: "UndateSoundStatus"), object: nil)
    }
    
    func createMuteSoundButton() {
        soundMuted = UserDefaultsManager.shared.checkSoundPreferences()
        self.view.addSubview(soundButton)
        if soundMuted == false {
            soundButton.setImage(UIImage(systemName: "speaker.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)), for: .normal)
            
        } else {
            soundButton.setImage(UIImage(systemName: "speaker.slash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)), for: .normal)
        }
        soundButton.addTarget(self, action: #selector(muteSoundButtonTapped), for: .touchUpInside)
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            soundButton.widthAnchor.constraint(equalToConstant: 40),
            soundButton.heightAnchor.constraint(equalToConstant: 40),
            soundButton.topAnchor.constraint(equalTo: view.topAnchor, constant: ParametrsStruct.spacer),
            soundButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -ParametrsStruct.spacer / 2)
        ])
    }
    
    @objc func muteSoundButtonTapped(_ sender: UIButton) {
        
        if soundMuted == false {
            sender.setImage(UIImage(systemName: "speaker.slash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)), for: .normal)
            
            MusicManager.shared.soundMuted = true
            soundMuted = true
            UserDefaultsManager.shared.muteSound(true)
            
        } else {
            sender.setImage(UIImage(systemName: "speaker.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)), for: .normal)
            
            MusicManager.shared.soundMuted = false
            soundMuted = false
            UserDefaultsManager.shared.muteSound(false)
            MusicManager.shared.playTick()
        }
        let soundDataDict : [String: Bool] = ["soundMuted": soundMuted]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UndateSoundStatus"), object: nil, userInfo: soundDataDict)
    }
    
    func createBackToMenuButton() {
        
        backToMenuButton.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)), for: .normal)
        self.view.addSubview(backToMenuButton)
        
        backToMenuButton.addTarget(self, action: #selector(backToMenuButtonTapped), for: .touchUpInside)
        backToMenuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backToMenuButton.widthAnchor.constraint(equalToConstant: 40),
            backToMenuButton.heightAnchor.constraint(equalToConstant: 40),
            backToMenuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: ParametrsStruct.spacer),
            backToMenuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ParametrsStruct.spacer / 2)
        ])
    }
    
    @objc func backToMenuButtonTapped(_ sender: UIButton) {
        MusicManager.shared.playTick()
        self.dismiss(animated: true)
    }
    
    @objc func updateSoundStatus(_ notification: NSNotification) {
        
        soundMuted = notification.userInfo?["soundMuted"] as! Bool
        
        if soundMuted == false {
            soundButton.setImage(UIImage(systemName: "speaker.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)), for: .normal)
            
        } else {
            soundButton.setImage(UIImage(systemName: "speaker.slash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)), for: .normal)
        }
    }
    
}

