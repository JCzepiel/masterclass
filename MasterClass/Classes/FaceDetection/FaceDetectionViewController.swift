//
//  FaceDetectionViewController.swift
//  FaceDetectionLBTA
//
//  Created by James Czepiel on 12/7/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit
import Vision

class FaceDetectionViewController: UIViewController {

    // For MasterClass we need to take into account the navbar, but constraints are confusing since the redView drawing is based on the view frame
    // So lets just do it like this
    let yOffset: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "sample2") else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        
        imageView.frame = CGRect(x: 0, y: 0 + yOffset, width: view.frame.width, height: scaledHeight)
        
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("error = \(error)")
                return
            }
            
            request.results?.forEach({ (result) in
                
                guard let faceObservation = result as? VNFaceObservation else { return }
                
                DispatchQueue.main.async {
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let y = scaledHeight * (1 - faceObservation.boundingBox.origin.y) - height
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    let redView = UIView()
                    redView.alpha = 0.4
                    redView.backgroundColor = .red
                    redView.frame = CGRect(x: x, y: y + self.yOffset, width: width, height: height)
                    self.view.addSubview(redView)
                }
                

            })
        }
        
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
                
            } catch let error {
                print("error = \(error)")
            }
        }
        

    }


}

