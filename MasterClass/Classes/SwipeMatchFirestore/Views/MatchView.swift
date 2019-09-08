//
//  MatchView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 1/21/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit
import Firebase

class MatchView: UIView {
    
    var cardUID: String? {
        didSet {
            guard let cardUID = cardUID else { return }
            
            let query = Firestore.firestore().collection("users")
            query.document(cardUID).getDocument { (snapshot, error) in
                if let error = error {
                    print("couldn ot fetch user with error = \(error as Any)")
                    return
                }
                
                guard let dictionary = snapshot?.data() else { return }
                let user = SwipeMatchFirestoreUser(dictionary: dictionary)
                guard let url = URL(string: user.imageUrl1 ?? ""), let name = user.name else { return }
                
                self.descriptionLabel.text = "You and \(name) have liked\neach other"
                
                self.cardUserImageView.sd_setImage(with: url) { _, _, _, _ in
                    guard let currentUser = self.currentUser, let currentUserImageURL = URL(string: currentUser.imageUrl1 ?? "") else { return }
                    
                    self.currentUserImageView.sd_setImage(with: currentUserImageURL) { _, _, _, _ in
                        self.setupAnimations()
                    }
                }
            }
        }
    }
    
    var currentUser: SwipeMatchFirestoreUser?
    fileprivate let imageWidth: CGFloat  = 140
    
    fileprivate lazy var currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "photo_placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageWidth / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate lazy var cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "photo_placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageWidth / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let itsAMatchImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and x have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let sendMessageButton: SendMessageButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("Send Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    fileprivate let keepSwipingButton: KeepSwipingButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var views = [
        itsAMatchImageView,
        descriptionLabel,
        currentUserImageView,
        cardUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        
        setupLayout()
    }
    
    fileprivate func setupAnimations() {
        views.forEach { $0.alpha = 1 }
        
        // Starting positions
        let angle = 30 * CGFloat.pi / 180
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)

        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45, animations: {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            })

            
        })
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.keepSwipingButton.transform = .identity
            self.sendMessageButton.transform = .identity
        }, completion: nil)
    }
    
    fileprivate func setupLayout() {
        views.forEach {
            addSubview($0)
            $0.alpha = 0
        }
        
        itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: imageWidth, height: imageWidth))
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: imageWidth, height: imageWidth))
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
    }
    
    fileprivate func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualBlurEffect = UIVisualEffectView(effect: blurEffect)
        addSubview(visualBlurEffect)
        visualBlurEffect.fillSuperview()
        visualBlurEffect.alpha = 0
        
        visualBlurEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            visualBlurEffect.alpha = 1
        })
    }
    
    @objc fileprivate func handleTapDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
