//
//  BottomPopUpScreenTestViewController.swift
//  BottomPopUpScreenTest
//
//  Created by James Czepiel on 5/24/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class BottomPopUpScreenTestViewController: UIViewController {
    
    
    lazy var bottomPopUpScreenView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .yellow
        textView.font = .systemFont(ofSize: 18)
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget orci vitae elit cursus rutrum eu ac ligula. Suspendisse potenti. Quisque nec velit scelerisque, pellentesque quam sed, convallis diam. Nulla facilisi. Nunc mi lorem, sollicitudin euismod tincidunt in, dapibus varius arcu. Aliquam mollis eros ut elit sodales tempus. In imperdiet ante sed orci tincidunt, consectetur elementum nunc ornare. Suspendisse egestas interdum purus, sit amet aliquet nisl vestibulum in. Pellentesque consectetur iaculis egestas. Phasellus vitae nibh ac dui maximus aliquet non vitae arcu. Nullam consectetur diam sed arcu luctus hendrerit. Vestibulum a libero tortor. Fusce a sapien at dui pharetra hendrerit."
        
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
        return view
    }()

    var bottomPopUpScreenViewTopConstraint: NSLayoutConstraint?
    var bottomPopUpScreenViewBottomConstraint: NSLayoutConstraint?
    var bottomPopUpScreenViewLeadingConstraint: NSLayoutConstraint?
    var bottomPopUpScreenViewTrailingConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .orange
        
        view.addSubview(bottomPopUpScreenView)
        
        bottomPopUpScreenViewTopConstraint = bottomPopUpScreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 1.4)
        bottomPopUpScreenViewTopConstraint?.isActive = true
        
        bottomPopUpScreenViewBottomConstraint = bottomPopUpScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomPopUpScreenViewBottomConstraint?.isActive = true
        
        bottomPopUpScreenViewLeadingConstraint = bottomPopUpScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        bottomPopUpScreenViewLeadingConstraint?.isActive = true
        
        bottomPopUpScreenViewTrailingConstraint = bottomPopUpScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        bottomPopUpScreenViewTrailingConstraint?.isActive = true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bottomPopUpScreenViewTopConstraint?.constant = self.bottomPopUpScreenViewTopConstraint?.constant == self.view.frame.height / 1.4 ? 0 : self.view.frame.height / 1.4
            self.bottomPopUpScreenViewTopConstraint?.isActive = true
            
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

