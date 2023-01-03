//
//  MenuViewController.swift
//  Reaction Speed Game
//
//  Created by Denys Zahorskyi on 03.01.2023.
//

import UIKit

class MenuViewController: BackgroundSoundViewController {
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = ParametrsStruct.spacer
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backToMenuButton.isHidden = true
        
        let lastSavedBackGround = UserDefaultsManager.shared.retrieveLastSavedBackroundName()
        
        imageView.image = UIImage(named: lastSavedBackGround)!
        view.insertSubview(imageView, at: 0)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
        ])
        
        let playButton = createButton(title: "PLAY", color: .green)
        let infoButton = createButton(title: "GET INFO", color: .yellow)
        let colorPickerButton = createButton(title: "CHANGE BACKGROUND", color: .systemBlue)
        
        [playButton, infoButton, colorPickerButton].forEach{
            subview in
            stackView.addArrangedSubview(subview)
        }
    }
    
    func createButton(title: String, color: UIColor) -> UIButton {
        
        let button = UIButton()
        button.frame.size = CGSize(width: 100, height: 40)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.backgroundColor = color
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonAction(sender: UIButton!) {
        switch sender.currentTitle {
        case "PLAY":
            let vc = PlayViewController()
            vc.imageView.image = imageView.image
            MusicManager.shared.playTick()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        case "GET INFO":
            let vc = AlertViewController(titleLabelText: "HOW TO PLAY", result: ParametrsStruct.gameDescription)
            MusicManager.shared.playTick()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)

        default:
           // imageView.removeFromSuperview()
            let vc = PickerViewController()
            vc.imageView.image = imageView.image
            vc.delegate = self
            MusicManager.shared.playTick()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension MenuViewController: ColorPickerDelegate{
    
    func didSelect(imageName: String){
        
        imageView.image = UIImage(named: imageName)!
    }
    
}
