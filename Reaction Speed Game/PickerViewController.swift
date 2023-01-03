//
//  PickerViewController.swift
//  Reaction Speed Game
//
//  Created by Denys Zahorskyi on 03.01.2023.
//

import UIKit

protocol ColorPickerDelegate: AnyObject {
    func didSelect(imageName: String)
}

class PickerViewController: BackgroundSoundViewController {
    
    var selectedView: UIView = UIView()
    var selectedImageName: String?
    var soundButtonTag = 1
    
    var images: [[String : UIImage]] = [
        ["1" : UIImage(named: "1")!, "2" : UIImage(named: "2")!],
        ["3" : UIImage(named: "3")!, "4" : UIImage(named: "4")!]
    ]
    
    
    weak var delegate: ColorPickerDelegate?
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insertSubview(imageView, at: 0)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setUpColorPicker()
        
        changeBackgroundButton()
        
        createMuteSoundButton()

    }
    
    func setUpColorPicker(){
        let bigStack = UIStackView()
        bigStack.spacing = 8
        bigStack.axis = .horizontal
        bigStack.distribution = .fillEqually
        
        
        for row in 0..<images.count {
            
            let smallStack = UIStackView()
            smallStack.spacing = 8
            smallStack.axis = .vertical
            smallStack.distribution = .fillEqually
            
            let row = images[row]
            
            for image in row {
                let btn = UIButton()
                btn.setImage(image.value, for: .normal)
                btn.setTitle(image.key, for: .normal)
                
                smallStack.addArrangedSubview(btn)
                btn.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
            }
            bigStack.addArrangedSubview(smallStack)
        }
        
        view.addSubview(bigStack)
        bigStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bigStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bigStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigStack.widthAnchor.constraint(equalToConstant: 256),
            bigStack.heightAnchor.constraint(equalTo: bigStack.widthAnchor)
        ])
    }
    
    @objc func btnTapped(_ sender: UIButton) {
        selectedView.layer.borderWidth = 0
        selectedView = sender
        selectedImageName = sender.currentTitle
        
        imageView.image = UIImage(named: sender.currentTitle ?? "1")
        
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.red.cgColor
        MusicManager.shared.playTick()
    }
    
    func changeBackgroundButton(){
        let button = UIButton()
        self.view.addSubview(button)
        button.backgroundColor = .green
        button.setTitle("CHANGE BACKGROUND", for: .normal)
        button.titleLabel?.font.withSize(35)
        button.layer.cornerRadius = 5
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(changeBackgroundButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ParametrsStruct.spacer),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -ParametrsStruct.spacer),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ParametrsStruct.spacer),
            button.heightAnchor.constraint(equalToConstant: ParametrsStruct.buttonHeight)
        ])
    }
    
    @objc func changeBackgroundButtonTapped(_ sender: UIButton) {
        if let imageName = selectedImageName {
            UserDefaultsManager.shared.saveNewBackground(newBackgroundName: imageName)
            delegate?.didSelect(imageName: imageName)
        } else {
            delegate?.didSelect(imageName: "1")
        }
        MusicManager.shared.playTick()
        self.dismiss(animated: true)
    }
    

}

