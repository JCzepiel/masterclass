//
//  DrawSomethingViewController.swift
//  DrawSomethingLBTA
//
//  Created by James Czepiel on 2/14/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class DrawSomethingViewController: UIViewController {

    let canvas = Canvas()
    
    let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        return button
    }()
    
    let yellowSwatchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(changeStrokeColor), for: .touchUpInside)
        return button
    }()
    
    let redSwatchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(changeStrokeColor), for: .touchUpInside)
        button.layer.borderWidth = 1
        return button
    }()
    
    let blueSwatchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(changeStrokeColor), for: .touchUpInside)
        button.layer.borderWidth = 1
        return button
    }()
    
    let strokeWidthSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 2
        slider.maximumValue = 20
        slider.addTarget(self, action: #selector(changeStrokeWidth), for: .valueChanged)
        return slider
    }()
    
    override func loadView() {
        self.view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvas.backgroundColor = .white
        
        setupStackView()
    }
    
    @objc fileprivate func handleUndo() {
        canvas.undo()
    }
    
    @objc fileprivate func handleClear() {
        canvas.clear()
    }
    
    @objc fileprivate func changeStrokeColor(sender: UIButton) {
        guard let color = sender.backgroundColor?.cgColor else { return }
        
        canvas.changeColor(newColor: color)
    }
    
    @objc fileprivate func changeStrokeWidth(sender: UISlider) {
        canvas.changeStrokeWidth(newWidth: CGFloat(sender.value))
    }
    
    fileprivate func setupStackView() {
        let buttonsStackView = UIStackView(arrangedSubviews: [undoButton, clearButton])
        buttonsStackView.distribution = .fillEqually
        
        let colorsStackView = UIStackView(arrangedSubviews: [yellowSwatchButton, redSwatchButton, blueSwatchButton])
        colorsStackView.translatesAutoresizingMaskIntoConstraints = false
        colorsStackView.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [buttonsStackView, colorsStackView, strokeWidthSlider])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    }
}

