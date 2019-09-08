//
//  CADisplayLinkViewController.swift
//  CADisplayLinkLBTA
//
//  Created by James Czepiel on 11/27/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class CADisplayLinkViewController: UIViewController {
    
    let countingLabel = CountingLabel(startValue: 1, endValue: 10, animationDuration: 100)
    let wordsLabel = TypingLabel(desiredEndString: "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of light, it was the season of darkness, it was the spring of hope, it was the winter of despair.", animationDuration: 10)
    let stackView = StatsStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(countingLabel)
        view.addSubview(wordsLabel)
        view.addSubview(stackView)

        stackView.bottomAnchor.constraint(equalTo: countingLabel.topAnchor, constant: -32).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        countingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        countingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        countingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true

        wordsLabel.topAnchor.constraint(equalTo: countingLabel.bottomAnchor).isActive = true
        wordsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        wordsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        

    }
}

