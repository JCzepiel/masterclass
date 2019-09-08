//
//  CollectionViewColorCodeTester.swift
//  Apogei
//
//  Created by James Czepiel on 4/3/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class CollectionViewColorCodeTester: UIViewController {
    
    lazy var menuBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = .black
        
        let lightButton = UIButton(type: .system)
        lightButton.translatesAutoresizingMaskIntoConstraints = false
        lightButton.setTitle("Random Lighter", for: .normal)
        view.addSubview(lightButton)
        lightButton.betterAnchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.centerXAnchor)
        lightButton.addTarget(self, action: #selector(randomizeColorsAsLighter), for: .touchUpInside)
        
        let darkButton = UIButton(type: .system)
        darkButton.translatesAutoresizingMaskIntoConstraints = false
        darkButton.setTitle("Random Darker", for: .normal)
        view.addSubview(darkButton)
        darkButton.betterAnchor(top: view.topAnchor, leading: view.centerXAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        darkButton.addTarget(self, action: #selector(randomizeColorsAsDarker), for: .touchUpInside)

        return view
    }()
    
    var colorToDisplay: UIColor = {
        let hue: CGFloat = CGFloat.random(in: 0...360)/360
        let saturation: CGFloat = CGFloat.random(in: 0...100)/100
        let brightness: CGFloat = CGFloat.random(in: 0...100)/100
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return color
    }()
    
    var randomizeAsDarker: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(menuBar)
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        setupStackView()
    }
    
    fileprivate func setupStackView() {
        var color = colorToDisplay
        
        // Go through many color variations
        let arrayOfColorViews = (0...15).compactMap { (int) -> UIView? in
            // Skip changing the color the first time so we display the starting color
            if int != 0 {
                color = randomizeAsDarker ? color.makeDarker(by: 0.05) : color.makeLighter(by: 0.05)
            }
            
            // The view will display the color
            let view = UIView()
            // The label will display the HSB values of the color if possible
            let label = UILabel()
            
            var printHue: CGFloat = 0/360
            var printSaturation: CGFloat = 0/100
            var printBrightness: CGFloat = 0/100
            var printAlpha: CGFloat = 0/100
            if color.getHue(&printHue, saturation: &printSaturation, brightness: &printBrightness, alpha: &printAlpha) {
                label.text = "Hue: \(String(format: "%.5f", printHue)) Saturation: \(String(format: "%.5f", printSaturation)) Brigtness: \(String(format: "%.5f", printBrightness))"
                label.font = UIFont.systemFont(ofSize: 12)
                label.backgroundColor = .clear
                view.addSubview(label)
                label.fillSuperview()
                
                if color.isDarkColor() {
                    label.textColor = .white
                }
            }
            
            view.backgroundColor = color
            return view
        }
        
        let stackView = UIStackView(arrangedSubviews: arrayOfColorViews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc fileprivate func randomizeColorsAsDarker() {
        randomizeAsDarker = true
        randomizeColors()
    }

    @objc fileprivate func randomizeColorsAsLighter() {
        randomizeAsDarker = false
        randomizeColors()
    }
    
    @objc fileprivate func randomizeColors() {
        let hue: CGFloat = CGFloat.random(in: 0...360)/360
        let saturation: CGFloat = CGFloat.random(in: 0...100)/100
        let brightness: CGFloat = CGFloat.random(in: 0...100)/100
        let newColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        colorToDisplay = newColor
        
        setupStackView()
    }
}
