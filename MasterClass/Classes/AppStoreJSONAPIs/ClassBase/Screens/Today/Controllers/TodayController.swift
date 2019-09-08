//
//  TodayController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/26/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class TodayController: BaseListController {
    
    // MARK: - Properties
    
    static let cellHeight: CGFloat = 500
    
    fileprivate var dataToDisplay = [TodayModel]()
    
    var topGrossingGroup: AppGroup? {
        didSet {
            guard let _ = topGrossingGroup else { return }
            
        }
    }
    
    var gamesGroup: AppGroup? {
        didSet {
            guard let _ = gamesGroup else { return }
            
        }
    }
    
    fileprivate var startingFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    fileprivate var todayFullscreenController: TodayFullScreenController?
    fileprivate var anchoredConstraints: AnchoredConstraints?
    fileprivate let blurVisualEffectview = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    fileprivate var appFullscreenBeginOffset: CGFloat = 0
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    let customBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(blurVisualEffectview)
        blurVisualEffectview.fillSuperview()
        blurVisualEffectview.isHidden = true
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayModel.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayModel.CellType.multiple.rawValue)

        collectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
        
        view.addSubview(customBackButton)
        customBackButton.betterAnchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }

    fileprivate func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AppStoreAPI.shared.fetchTopGrossing { (group, error) in
            dispatchGroup.leave()
            
            self.topGrossingGroup = group
        }
        
        dispatchGroup.enter()
        AppStoreAPI.shared.fetchNewGames { (group, error) in
            dispatchGroup.leave()
            
            self.gamesGroup = group
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            
            self.dataToDisplay.append(TodayModel(cellType: .single, category: "RPG", title: "Pathfinder: Kingmaker", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, apps: []))
            self.dataToDisplay.append(TodayModel(cellType: .single, category: "RPG", title: "Pathfinder: Kingmaker", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: UIColor(red: 47/255, green: 70/255, blue: 50/255, alpha: 1), apps: []))
            self.dataToDisplay.append(TodayModel(cellType: .multiple, category: "Daily List", title: self.topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "holiday"), description: "", backgroundColor: .white, apps: self.topGrossingGroup?.feed.results ?? []))
            self.dataToDisplay.append(TodayModel(cellType: .multiple, category: "Daily List", title: self.gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "holiday"), description: "", backgroundColor: .white, apps: self.gamesGroup?.feed.results ?? []))
            self.dataToDisplay.append(TodayModel(cellType: .single, category: "FPS", title: "The Division 2", image: #imageLiteral(resourceName: "holiday"), description: "", backgroundColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), apps: []))


            self.collectionView.reloadData()
        }
    }

    @objc fileprivate func handleMultipleAppsTap(guesture: UITapGestureRecognizer) {
        if let collectionView = guesture.view as? UICollectionView {
            var superview = collectionView.superview
            while superview != nil {
                if let cell = superview as? TodayMultipleAppCell {
                    guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                    
                    let fullController = TodayMultipleAppsController(mode: .fullscreen)
                    let apps = self.dataToDisplay[indexPath.item].apps
                    fullController.dataToDisplay = apps
                    present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
                    return
                }
                
                superview = superview?.superview
            }
        }
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension TodayController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = dataToDisplay[indexPath.item]
        
        switch data.cellType {
        case .multiple:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayModel.CellType.multiple.rawValue, for: indexPath) as? TodayMultipleAppCell else { return UICollectionViewCell() }
            cell.dataToDisplay = data
            cell.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
            return cell
        case .single:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayModel.CellType.single.rawValue, for: indexPath) as? TodayCell else { return UICollectionViewCell() }
            cell.dataToDisplay = data
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TodayController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 64, height: TodayController.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}

// MARK: - UIGestureRecognizerDelegate

extension TodayController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UICollectionViewDelegate

extension TodayController {
    

    @objc fileprivate func handleRemoveTodayFullscreen() {
        blurVisualEffectview.isHidden = true
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.todayFullscreenController?.tableView.contentOffset = .zero

            self.todayFullscreenController?.view.transform = .identity
            
            self.anchoredConstraints?.top?.constant = self.startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = self.startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = self.startingFrame.width
            self.anchoredConstraints?.height?.constant = self.startingFrame.height
            self.view.layoutIfNeeded()

            self.tabBarController?.tabBar.transform = .identity
            
            guard let cell = self.todayFullscreenController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TodayFullscreenImageCell else { return }
            self.todayFullscreenController?.closeButton.alpha = 0
            cell.todayCell.topConstraint?.constant = 24
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            self.todayFullscreenController?.view?.removeFromSuperview()
            self.todayFullscreenController?.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TodayCell else { return }
        
        // Need to get absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }
    
    fileprivate func showDailyListFullscreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.dataToDisplay = dataToDisplay[indexPath.item].apps
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let todayFullscreenController = TodayFullScreenController()
        todayFullscreenController.view.layer.cornerRadius = 16
        todayFullscreenController.dataToDisplay = dataToDisplay[indexPath.item]
        todayFullscreenController.dismissHandler = {
            self.handleRemoveTodayFullscreen()
        }
        addChild(todayFullscreenController)
        self.todayFullscreenController = todayFullscreenController
        
        // Add gesture to handle swipe to dismiss
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeToDismiss))
        gesture.delegate = self
        self.todayFullscreenController?.view.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func handleSwipeToDismiss(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            appFullscreenBeginOffset = todayFullscreenController?.tableView.contentOffset.y ?? 0
        }
        
        let translationY = gesture.translation(in: self.todayFullscreenController?.view).y
        
        if self.todayFullscreenController?.tableView.contentOffset.y ?? 0 > CGFloat(0) {
            return
        }
        
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset
                
                var scale = 1 - trueOffset / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)
                let transform: CGAffineTransform = CGAffineTransform(scaleX: scale, y: scale)
                self.todayFullscreenController?.view.transform = transform
            }
            
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleRemoveTodayFullscreen()
            }
        }
    }
    
    fileprivate func setupSingleAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        guard let todayFullscreenControllerView = todayFullscreenController?.view else { return }
        view.addSubview(todayFullscreenControllerView)
        
        setupStartingCellFrame(indexPath)
    
        self.anchoredConstraints = todayFullscreenControllerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
    }
    
    fileprivate func beginFullscreenControllerAnimation() {
        // Add blur effect to background so it looks good when we swipe to dismiss
        blurVisualEffectview.isHidden = false
        
        self.collectionView.isUserInteractionEnabled = false
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            guard let cell = self.todayFullscreenController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TodayFullscreenImageCell else { return }
            cell.todayCell.topConstraint?.constant = 44
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    fileprivate func showSingleAppFullscreen(_ indexPath: IndexPath){
        setupSingleAppFullscreenController(indexPath)
        
        setupSingleAppFullscreenStartingPosition(indexPath)
        
        beginFullscreenControllerAnimation()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch dataToDisplay[indexPath.item].cellType {
        case .multiple:
            showDailyListFullscreen(indexPath)
        case.single:
            showSingleAppFullscreen(indexPath)
        }
    }
}
