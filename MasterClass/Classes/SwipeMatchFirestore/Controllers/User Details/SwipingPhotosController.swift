//
//  SwipingPhotosController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 1/9/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "ACO3"))

    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var controllers = [UIViewController]()
    
    var cardViewModel: CardViewModel? {
        didSet {
            guard let cardViewModel = cardViewModel else { return }
            
            controllers = cardViewModel.imageUrls.map({ imageUrlString -> PhotoController in
                let photoController = PhotoController(imageUrl: imageUrlString)
                return photoController
            })
            
            if let hasFirstController = controllers.first {
                setViewControllers([hasFirstController], direction: .forward, animated: true)
            }
            
            setupBarViews()
        }
    }
    
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
    
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate let isCardViewMode: Bool
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if isCardViewMode {
            disableSwiping()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        guard let currentController = viewControllers?.first else { return }
        guard let index = controllers.firstIndex(of: currentController) else { return }
        barsStackView.arrangedSubviews.forEach({ $0.backgroundColor = deselectedBarColor })

        if gesture.location(in: self.view).x > view.frame.width / 2 {
            let nextIndex = min(index + 1, controllers.count - 1)
            let nextController = controllers[nextIndex]
            setViewControllers([nextController], direction: .forward, animated: false)
            barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
        } else {
            let nextIndex = max(0, index - 1)
            let nextController = controllers[nextIndex]
            setViewControllers([nextController], direction: .reverse, animated: false)
            barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    fileprivate func setupBarViews() {
        cardViewModel?.imageUrls.forEach({ _ in
            let barView = UIView()
            barView.backgroundColor = deselectedBarColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        })
        
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 4
        
        view.addSubview(barsStackView)
        let paddingTop = isCardViewMode ? 8 : UIApplication.shared.statusBarFrame.height + 8
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    fileprivate func disableSwiping() {
        view.subviews.forEach { (view) in
            if let view = view as? UIScrollView {
                view.isScrollEnabled = false
            }
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        guard let index = controllers.firstIndex(where: { $0 == currentPhotoController }) else { return }
        barsStackView.arrangedSubviews.forEach({ $0.backgroundColor = deselectedBarColor })
        barsStackView.arrangedSubviews[index].backgroundColor = .white
        
    }
}
