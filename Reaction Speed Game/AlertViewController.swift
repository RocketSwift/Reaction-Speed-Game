//
//  AlertViewController.swift
//  Reaction Speed Game
//
//  Created by Denys Zahorskyi on 03.01.2023.
//

import UIKit

class AlertViewController: UIViewController {
    
    var action: (() -> ())?
    
    var secondaryAction : (() -> ())?
    
    var result: String
    var titleLabelText: String
    
    lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 15
        stackView.backgroundColor = .gray.withAlphaComponent(0.95)
        stackView.layer.cornerRadius = 25
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    init(titleLabelText: String, result: String) {
        self.titleLabelText = titleLabelText
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85)
        ])
        
        createTitleLabel()
        createInfoLabel()
        createDismissButton()
        createHiddenButton()
    }
    
    func createTitleLabel(){
        let myTitleLabel = UILabel()
        myTitleLabel.textAlignment = .center
        myTitleLabel.text = titleLabelText
        myTitleLabel.textColor = .white
        myTitleLabel.font = UIFont.boldSystemFont(ofSize: 35.0)
        myTitleLabel.alpha = 1
        stackView.addArrangedSubview(myTitleLabel)
    }
    
    func createInfoLabel(){
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.text = result
        textLabel.numberOfLines = 0
        textLabel.textColor = .white
        textLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        textLabel.alpha = 1
        stackView.addArrangedSubview(textLabel)
    }
    
    func createDismissButton(){
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.layer.cornerRadius = 5
        stackView.addArrangedSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        MusicManager.shared.playTick()
        if action != nil{
            action!()
        }
        self.dismiss(animated: true)
    }
    
    func createHiddenButton(){
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("BACK TO MENU", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(hiddenButtonAction), for: .touchUpInside)
        button.layer.cornerRadius = 5
        if secondaryAction == nil{
            button.isHidden = true
        } else {
            button.isHidden = false
        }
        
        stackView.addArrangedSubview(button)
    }
    
    @objc func hiddenButtonAction(sender: UIButton!) {
        
        self.dismiss(animated: true)
        
        if secondaryAction != nil{
            secondaryAction!()
        }
    }
}

