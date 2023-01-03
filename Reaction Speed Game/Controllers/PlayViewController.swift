//
//  PlayViewController.swift
//  Reaction Speed Game
//
//  Created by Denys Zahorskyi on 03.01.2023.
//

import UIKit

class PlayViewController: BackgroundSoundViewController {
    
    let button = UIButton(type: .custom)
    var gameStartedTime = TimeInterval()
    let buttonWidthAndHeight = 75.0
    var count = 0
    
    var resultsArray = [Double]()
    var bestResult: Double = 0
    
    let nc = NotificationCenter.default
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
        createBackground()
        
    }
    
    func createBackground(){
        view.insertSubview(imageView, at: 0)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func startGame(){
        let countDownLabel = UILabel()
        self.view.addSubview(countDownLabel)
        countDownLabel.textAlignment = .center
        countDownLabel.text = ""
        
        countDownLabel.font = UIFont.boldSystemFont(ofSize: 200.0)
        countDownLabel.alpha = 1
        countDownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countDownLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            countDownLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            countDownLabel.heightAnchor.constraint(equalToConstant: 300),
            countDownLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        var secondsRemaining = 3
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if secondsRemaining > 0 {
                countDownLabel.text = String(secondsRemaining)
                countDownLabel.textColor = self.getRandomColor()
                secondsRemaining -= 1
                MusicManager.shared.playTick()
            } else {
                Timer.invalidate()
                countDownLabel.removeFromSuperview()
                self.createPlayButton()
                MusicManager.shared.playStart()
                self.gameStartedTime = Date().timeIntervalSinceReferenceDate
            }
        }
        
    }
    
    func createPlayButton(){
        
        button.backgroundColor = .green
        button.setTitle("catch", for: .normal)
        button.titleLabel?.font.withSize(3)
        button.layer.cornerRadius = 35.0
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(catchMeButtonPressed), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        button.frame.origin = getRandomButtonPosition()
        
        self.view.addSubview(button)
        
    }
    
    @objc func catchMeButtonPressed(sender: UIButton!) {
        
        count += 1
        
        if count == 5 {
            
            gameEnded()
            
        } else {
            MusicManager.shared.playTick()
            var newRandomPosition = getRandomButtonPosition()
            
            while abs (newRandomPosition.y - sender.frame.origin.y) < sender.frame.height * 2 {
                newRandomPosition = getRandomButtonPosition()
            }
            sender.frame.origin = newRandomPosition
            sender.backgroundColor = getRandomColor()
        }
        
    }
    
    func getRandomColor() -> UIColor{
        let randomColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        return randomColor
    }
    
    func getRandomButtonPosition() -> CGPoint{
        let randomPosition = CGPoint(
            x: .random(in: view.safeAreaLayoutGuide.layoutFrame.minX...view.safeAreaLayoutGuide.layoutFrame.maxX - buttonWidthAndHeight),
            y: .random(in: view.safeAreaLayoutGuide.layoutFrame.minX + buttonWidthAndHeight...view.safeAreaLayoutGuide.layoutFrame.maxY - buttonWidthAndHeight))
        return randomPosition
    }
    
    func gameEnded(){
        
        var resultType = ""
        
        count = 0
        
        let gameEndedTime = Date().timeIntervalSinceReferenceDate
        
        let resultTime = abs(round((gameStartedTime - gameEndedTime) * 100) / 100)
        
        resultsArray = UserDefaultsManager.shared.retrievePreviousResults()
        
        resultsArray.append(resultTime)
        
        UserDefaultsManager.shared.addNewResult(add: resultsArray)
        
        if resultsArray.count == 1 {
            bestResult = resultsArray.first!
        } else {
            resultsArray.sort(by: { $0 < $1 })
            bestResult = resultsArray.first!
        }
        
        if resultTime == bestResult{
            resultType = "Your result is \(resultTime) \n NEW BEST RESULT!"
            MusicManager.shared.playWin()
        } else {
            resultType = "Your result is \(resultTime) \n Current best result is \(bestResult)"
            MusicManager.shared.playOver()
        }
        
        let vc = AlertViewController(titleLabelText: "GAME OVER", result: resultType)
        vc.action = {self.restartGame()}
        vc.secondaryAction = {self.goToMenu()}
        
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func restartGame() {
        button.removeFromSuperview()
        self.startGame()
        gameStartedTime = Date().timeIntervalSinceReferenceDate
    }
    
    func goToMenu() {
        self.dismiss(animated: true)
    }
    
}

