//
//  JCProgressView.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/19/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

struct JCProgressCacheData {
    let activityIndicator: UIActivityIndicatorView
    let containerView: UIView
}

class JCProgressView {
    static let shared = JCProgressView()
    
    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    var jcProgressViewCache: [Int: JCProgressCacheData] = [:]
    
    func showProgressView(in view: UIView, backgroundTransparent: Bool = false) {
        let key = view.hash
        
        if jcProgressViewCache[key] != nil {
            // If we already made a progress indicator for this view and it is still in cache, we don't need to make another
            return
        }
        
        let newContainerView = UIView()
        newContainerView.translatesAutoresizingMaskIntoConstraints = false
        let newActivityIndicator = UIActivityIndicatorView()
        newActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(newContainerView)
        newContainerView.fillSuperview()
        newContainerView.backgroundColor = backgroundTransparent ? .clear : .black
        
        newContainerView.addSubview(newActivityIndicator)
        newActivityIndicator.centerYAnchor.constraint(equalTo: newContainerView.centerYAnchor).isActive = true
        newActivityIndicator.centerXAnchor.constraint(equalTo: newContainerView.centerXAnchor).isActive = true
        newActivityIndicator.style = .whiteLarge
        newActivityIndicator.color = .darkGray
        newActivityIndicator.startAnimating()
        
        jcProgressViewCache[key] = JCProgressCacheData(activityIndicator: newActivityIndicator, containerView: newContainerView)
    }
    
    func hideProgressView(in view: UIView) {
        let key = view.hash
        
        if let hasViewCached = jcProgressViewCache[key] {
            hasViewCached.activityIndicator.stopAnimating()
            hasViewCached.containerView.removeFromSuperview()
            jcProgressViewCache[key] = nil
        }
    }
    
    func showProgressViewInWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        containerView.frame = window.frame
        containerView.center = window.center
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        progressView.center = containerView.center
        progressView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: progressView.bounds.width/2, y: progressView.bounds.height/2)
        
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        
        UIApplication.shared.keyWindow?.addSubview(containerView)
        
        activityIndicator.startAnimating()
    }
    
    func hideProgressViewInWindow() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}
