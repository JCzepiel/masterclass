//
//  MagicalGridViewController.swift
//  MagicalGridLBTA
//
//  Created by James Czepiel on 12/4/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class MagicalGridViewController: UIViewController {

    let numberOfViewsPerRow = 15
    lazy var width = view.frame.width / CGFloat(numberOfViewsPerRow)

    var cells = [String: UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for column in 0...30 {
            for row in 0...numberOfViewsPerRow {
                let cellView = UIView()
                cellView.backgroundColor = randomColor()
                cellView.frame = CGRect(x: CGFloat(row) * width, y: CGFloat(column) * width, width: width, height: width)
                cellView.layer.borderWidth = 0.5
                cellView.layer.borderColor = UIColor.black.cgColor
                view.addSubview(cellView)
                
                let key = "\(row)|\(column)"
                cells[key] = cellView
            }
        }

        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    var selectedCell: UIView?
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)

        let columnOfTouch = Int(location.x / width)
        let rowOfTouch = Int(location.y / width)
        let key = "\(columnOfTouch)|\(rowOfTouch)"

        guard let cellView = cells[key] else { return }
        if selectedCell != cellView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.selectedCell?.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        
        selectedCell = cellView
        view.bringSubviewToFront(cellView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            cellView.layer.transform = CATransform3DMakeScale(3, 3, 3)
        }, completion: nil)
        
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                cellView.layer.transform = CATransform3DIdentity
            }, completion: { (_) in
                
            })
        }
    }
    
    fileprivate func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }


}

