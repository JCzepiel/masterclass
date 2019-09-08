//
//  ViewController.swift
//  ChainedAnimationsLBTA
//
//  Created by James Czepiel on 11/27/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//  https://www.youtube.com/watch?v=xWNv-j75OQ8

import UIKit

class ChainedAnimationsViewController: UIViewController {
    
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    
    var doAnimation = true

    fileprivate func setupLabels() {
        titleLabel.numberOfLines = 0
        titleLabel.text = "Welcome to Company XYZ"
        titleLabel.font = UIFont(name: "Futura", size: 34)

        bodyLabel.numberOfLines = 0
        bodyLabel.text = "Hello there! Thanks so much for downloading our brand new app and giving us a try. Make sure to leave us a good review in the app store!"
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        
        stackView.backgroundColor = .yellow
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLabels()
        setupStackView()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAnimations)))
    }

    @objc fileprivate func handleTapAnimations() {
        
        if doAnimation {
            startAnimation()
            //doAnimation = false
        } else {
            resetAnimation()
            doAnimation = true
        }
    }

    fileprivate func startAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.titleLabel.alpha = 0
                self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -200)
                
            }, completion: { (_) in
            })
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.bodyLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bodyLabel.alpha = 0
                self.bodyLabel.transform = self.bodyLabel.transform.translatedBy(x: 0, y: -200)
                
            })
        }
    }
    
    fileprivate func resetAnimation() {
        self.titleLabel.alpha = 1
        self.bodyLabel.alpha = 1

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.titleLabel.transform = CGAffineTransform(translationX: 30, y: 0)
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: 200)
                
            }, completion: { (_) in
            })
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.bodyLabel.transform = CGAffineTransform(translationX: 30, y: 0)
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bodyLabel.transform = self.bodyLabel.transform.translatedBy(x: 0, y: 200)
                
            })
        }
    }
}

