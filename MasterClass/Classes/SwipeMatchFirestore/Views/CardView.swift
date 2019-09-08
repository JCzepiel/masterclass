//
//  CardView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 12/17/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel?)
    func didRemoveCard(cardView: CardView, withLiked: Bool)
}

class CardView: UIView {
    
    // MARK: - Properties
    
    var nextCardView: CardView?
    
    var cardViewModel: CardViewModel? {
        didSet {
            guard let cardViewModel = cardViewModel else { return }
            
            swipingPhotosController.cardViewModel = cardViewModel

            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    //fileprivate let imageView = UIImageView()
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    
    fileprivate var informationLabel = UILabel()
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate let barsStackView = UIStackView()
    
    let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    var delegate: CardViewDelegate?
    
    // MARK: - Configurations
    
    fileprivate let panDismissThreshold: CGFloat = 120
    
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)

    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupGradientLayer()
        setupInformationLabel()
        //setupBars()
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // Set the correct gradient frame once we know what it iss
        gradientLayer.frame = frame
    }
    
    // MARK: - Fileprivate
    
    fileprivate func setupBars() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.8, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    fileprivate func setupImageView() {
        guard let swipingPhotosView = swipingPhotosController.view else { return }
        
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
    }
    
    fileprivate func setupInformationLabel() {
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel?.imageIndexObserver = { [weak self] index, imageUrl in
            
            self?.barsStackView.arrangedSubviews.forEach({ $0.backgroundColor = self?.barDeselectedColor })
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white

        }
    }
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel)
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        guard let cardViewModel = cardViewModel else { return }

        let tapLocation = gesture.location(in: self)
        let shouldAdvanceToNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceToNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            // Remove all pending animations when we start a new one or else things get unpredicable
            superview?.subviews.forEach({ (view) in
                view.layer.removeAllAnimations()
            })
        case .changed:
            handlePanChangedGesture(gesture)
        case .ended:
            handlePanEndedGesture(gesture)
        default:
            break
        }
    }
    
    fileprivate func handlePanChangedGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)

        let degrees: CGFloat = translation.x / 20 // 20 just slows down the rotation effect
        let angle = degrees * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handlePanEndedGesture(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > panDismissThreshold
        
        if shouldDismissCard {
            self.isUserInteractionEnabled = false
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: (UIScreen.main.bounds.width * 2) * translationDirection , y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
        }, completion: { completedAnimation in
            self.transform = .identity
            
            if shouldDismissCard {
                self.removeFromSuperview()
                self.delegate?.didRemoveCard(cardView: self, withLiked: translationDirection > 0 ? true : false)
            }
        })
    }
    
}
