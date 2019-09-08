//
//  AnimatedCircleViewController.swift
//  AnimatedCircleLBTA
//
//  Created by James Czepiel on 12/3/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
}

class AnimatedCircleViewController: UIViewController, URLSessionDownloadDelegate {
    
    lazy var progressBarLayer: CAShapeLayer = {
        let layer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        return layer
    }()
    
    lazy var progressBarBackgroundLayer: CAShapeLayer = {
        let layer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        return layer
    }()
    
    lazy var pulsatingLayer: CAShapeLayer = {
        let layer = createCircleShapeLayer(strokeColor: .clear, fillColor: .pulsatingFillColor)
        return layer
    }()
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32.0)
        label.textColor = .white
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let circleShapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        circleShapeLayer.path = circularPath.cgPath
        circleShapeLayer.strokeColor = strokeColor.cgColor
        circleShapeLayer.lineWidth = 20
        circleShapeLayer.fillColor = fillColor.cgColor
        circleShapeLayer.lineCap = .round
        circleShapeLayer.position = view.center
        
        return circleShapeLayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        
        view.backgroundColor = .backgroundColor
        
        animatePulsatingLayer()
        view.layer.addSublayer(pulsatingLayer)
        
        view.layer.addSublayer(progressBarBackgroundLayer)
        
        progressBarLayer.strokeEnd = 0
        progressBarLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(progressBarLayer)
        
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        view.addSubview(percentageLabel)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc fileprivate func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    fileprivate func beginDownloadingFile() {
        let urlString = "https://pbs.twimg.com/media/Ds0rfNuU4AAUA9E.jpg:large"
        
        progressBarLayer.strokeEnd = 0
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        print("Downloading... \(totalBytesWritten) out of \(totalBytesExpectedToWrite) = \(percentage)")

        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.progressBarLayer.strokeEnd = percentage
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Downloaded to location \(location)")
    }
    
    fileprivate func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        pulsatingLayer.add(animation, forKey: "pulsatingAnimation")
    }

    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        progressBarLayer.add(basicAnimation, forKey: "animateCircle")
    }
    
    @objc fileprivate func handleTap() {
        beginDownloadingFile()
    }

}

