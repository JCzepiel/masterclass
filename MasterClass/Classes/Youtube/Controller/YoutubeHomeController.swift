//
//  YoutubeHomeController.swift
//  youttube
//
//  Created by James Czepiel on 10/4/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

protocol YoutubeHomeControllerDelegate {
    func showSettingController(for setting: Setting)
    func scrollToMenuIndex(menuIndex: Int)
}

class YoutubeHomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, YoutubeHomeControllerDelegate {
    
    let feedCellId = "feedCellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"
    let titles = ["  Home", "  Trending", "  Subscriptions", "  Account"]

    let statusBarBackgroundView = UIView()
    var defaultNavigationBarTintColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20.0)
        navigationItem.titleView = titleLabel
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
        
        // This stuff was in this specific tutorials AppDelegate - it was adapted for this project
        let navigationBar = navigationController?.navigationBar
        defaultNavigationBarTintColor = navigationBar?.tintColor
        navigationBar?.barTintColor = UIColor.rgb(red: 230, green: 32, blue: 32)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.setBackgroundImage(UIImage(), for: .default)

        statusBarBackgroundView.backgroundColor = UIColor.rgb(red: 194, green: 31, blue: 31)
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(statusBarBackgroundView)
        window.addConstraintsWithFormat(format: "H:|[v0]|", view: statusBarBackgroundView)
        window.addConstraintsWithFormat(format: "V:|[v0(20)]", view: statusBarBackgroundView)
    }
    
    func setupCollectionView() {
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = .white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: feedCellId)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)

        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView.isPagingEnabled = true
    }
    
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.delegate = self
        return launcher
    }()
    
    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
    
    func showSettingController(for setting: Setting) {
        let settingViewController = UIViewController()
        settingViewController.view.backgroundColor = .white
        settingViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    @objc func handleSearch() {
    
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
        changeTitle(for: menuIndex)
    }
    
    lazy var menuBar: MenuBar = {
        let menuBar = MenuBar()
        menuBar.delegate = self
        return menuBar
    }()
    
    /*
     2018-10-08 15:44:59.175226-0400 youttube[1392:3813305] libMobileGestalt MobileGestalt.c:890: MGIsDeviceOneOfType is not supported on this platform.
     2018-10-08 15:45:50.576157-0400 youttube[1392:3813305] The behavior of the UICollectionViewFlowLayout is not defined because:
     2018-10-08 15:45:50.576286-0400 youttube[1392:3813305] the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values.
     2018-10-08 15:45:50.576742-0400 youttube[1392:3813305] The relevant UICollectionViewFlowLayout instance is <UICollectionViewFlowLayout: 0x7f9f96c04bd0>, and it is attached to <UICollectionView: 0x7f9f99850000; frame = (0 0; 375 667); clipsToBounds = YES; autoresize = W+H; gestureRecognizers = <NSArray: 0x6000024a8750>; animations = { position=<CABasicAnimation: 0x600002a98cc0>; bounds.origin=<CABasicAnimation: 0x600002a98e00>; bounds.size=<CABasicAnimation: 0x600002a98de0>; bounds.origin-2=<CABasicAnimation: 0x600002a98e80>; bounds.size-2=<CABasicAnimation: 0x600002a992e0>; }; layer = <CALayer: 0x600002ac14e0>; contentOffset: {68, -70}; contentSize: {1500, 553}; adjustedContentInset: {70, 0, 0, 0}> collection view layout: <UICollectionViewFlowLayout: 0x7f9f96c04bd0>.
     2018-10-08 15:45:50.576833-0400 youttube[1392:3813305] Make a symbolic breakpoint at UICollectionViewFlowLayoutBreakForInvalidSizes to catch this in the debugger.
     */
    
    private func setupMenuBar() {
        //navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 32)
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", view: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", view: redView)

        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", view: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", view: menuBar)

        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        
        if indexPath.item == 1 {
            identifier = trendingCellId
        } else if indexPath.item == 2 {
            identifier = subscriptionCellId
        } else {
            identifier = feedCellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x/view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        changeTitle(for: index)
    }
    
    func changeTitle(for index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = titles[index]
        }
    }
}


