//
//  MultipleAppsController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/29/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController {
    
    // MARK: - Properties
    
    enum Mode {
        case small
        case fullscreen
    }
    
    fileprivate let mode: Mode
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.addTarget(self, action: #selector(buttonDismiss), for: .touchUpInside)
        return button
    }()    

    fileprivate let cellId = "cellId"
    
    var dataToDisplay = [FeedResult]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate let itemSpacing: CGFloat = 16
    
    // MARK: - Life Cycle
    
    init(mode: Mode) {
        self.mode = mode
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
        
        if mode == .fullscreen {
            view.addSubview(closeButton)
            closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
            navigationController?.isNavigationBarHidden = true
        } else {
            collectionView.isScrollEnabled = false
        }
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    @objc fileprivate func buttonDismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension TodayMultipleAppsController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newController = BetterAppDetailController(appId: dataToDisplay[indexPath.item].id)
        navigationController?.pushViewController(newController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension TodayMultipleAppsController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .fullscreen {
            return dataToDisplay.count
        } else {
            return min(4, dataToDisplay.count)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MultipleAppCell else { return UICollectionViewCell() }
        cell.dataToDisplay = dataToDisplay[indexPath.item]
        return cell
    }
}

extension TodayMultipleAppsController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 68
        
        if mode == .fullscreen {
            return CGSize(width: view.frame.width - 48, height: height)
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullscreen {
            return UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        }
        
        return .zero
    }
}
