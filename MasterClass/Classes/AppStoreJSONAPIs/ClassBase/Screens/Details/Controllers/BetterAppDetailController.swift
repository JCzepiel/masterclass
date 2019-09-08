//
//  BetterAppDetailController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/24/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class BetterAppDetailController: BaseListController {
    
    // MARK: - Properties

    fileprivate let appDetailInfoCellId = "appDetailInfoCellId"
    fileprivate let appDetailScreenshotsCellId = "appDetailScreenshotsCellId"
    fileprivate let appDetailReviewsCellId = "appDetailReviewsCellId"
    
    fileprivate let appId: String
    
    fileprivate var dataToDisplay: Result?
    
    fileprivate var reviewsToDisplay: [Entry]?
    
    // MARK: - Init
    
    // Dependency Injection
    init(appId: String) {
        self.appId = appId
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        
        collectionView.register(AppDetailInfoCell.self, forCellWithReuseIdentifier: appDetailInfoCellId)
        collectionView.register(AppDetailScreenshotsCell.self, forCellWithReuseIdentifier: appDetailScreenshotsCellId)
        collectionView.register(AppDetailReviewsCell.self, forCellWithReuseIdentifier: appDetailReviewsCellId)

        fetchData()
    }
    
    fileprivate func fetchData() {
        AppStoreAPI.shared.fetchApp(id: appId) { (result, error) in
            
            if let result = result, result.results.count > 0 {
                self.dataToDisplay = result.results[0]
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        AppStoreAPI.shared.fetchReviewsForApp(id: appId) { (result, error) in
            if let result = result {
                self.reviewsToDisplay = result.feed.entry
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}

extension BetterAppDetailController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay != nil ? 3 : 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appDetailInfoCellId, for: indexPath) as? AppDetailInfoCell else { return UICollectionViewCell() }
            cell.dataToDisplay = dataToDisplay
            return cell
        } else if indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appDetailScreenshotsCellId, for: indexPath) as? AppDetailScreenshotsCell else { return UICollectionViewCell() }
            cell.dataToDisplay = dataToDisplay?.screenshotUrls
            return cell
        } else if indexPath.item == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appDetailReviewsCellId, for: indexPath) as? AppDetailReviewsCell else { return UICollectionViewCell() }
            cell.dataToDisplay = reviewsToDisplay
            return cell
        }

        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BetterAppDetailController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let dummyCell = AppDetailInfoCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummyCell.dataToDisplay = dataToDisplay
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            
            return CGSize(width: view.frame.width, height: estimatedSize.height)
        } else if indexPath.item == 1 {
            return CGSize(width: view.frame.width, height: 500)
        } else if indexPath.item == 2 {
            return CGSize(width: view.frame.width, height: 280)
        }
        
        
        return .zero

    }
}

