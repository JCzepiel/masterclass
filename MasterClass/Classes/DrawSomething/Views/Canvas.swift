//
//  Canvas.swift
//  DrawSomethingLBTA
//
//  Created by James Czepiel on 2/14/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class Canvas: UIView {
    
    fileprivate var lines = [DetailedLine]()
    
    fileprivate var strokeColor: CGColor = UIColor.black.cgColor
    fileprivate var strokeSize: CGFloat = 4
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        lines.forEach { (line) in
            for (index, detailedPoint) in line.points.enumerated() {
                if index == 0 {
                    context.move(to: detailedPoint)
                }
                
                context.addLine(to: detailedPoint)
            }
            
            context.setStrokeColor(line.color)
            context.setLineWidth(line.width)
            
            //Stroke after each DetailedLine so we maintain the correct strokeColor and width
            context.strokePath()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil), var lastLine = lines.popLast() else { return }
        
        lastLine.points.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(DetailedLine.init(points: [], color: strokeColor, width: strokeSize))
    }
    
    func undo() {
        lines.removeLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    func changeColor(newColor: CGColor) {
        strokeColor = newColor
    }
    
    func changeStrokeWidth(newWidth: CGFloat) {
        strokeSize = newWidth
    }
}
