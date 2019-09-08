//
//  AppsPageController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/19/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppsPageController: BaseListController {
    
    // MARK: - Properties
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    
    fileprivate var dataToDisplayForCells: [AppGroup] = []
    fileprivate var dataToDisplayForHeader: [SocialApp] = []

    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white

        collectionView.register(AppsRootCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
    }
    
    fileprivate func fetchData() {
        
        var group1: AppGroup?
        var group2: AppGroup?
        var group3: AppGroup?
        var socialGroup: [SocialApp]?

        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AppStoreAPI.shared.fetchNewGames { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error)
            }
            
            group1 = appGroup
        }
        
        dispatchGroup.enter()
        AppStoreAPI.shared.fetchTopGrossing { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error)
            }
            
            group2 = appGroup
        }
        
        dispatchGroup.enter()
        AppStoreAPI.shared.fetchTopFree { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error)
            }
            
            group3 = appGroup
        }
        
        dispatchGroup.enter()
        AppStoreAPI.shared.fetchSocialApps { (socialApps, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error)
            }
            
           socialGroup = socialApps
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()

            if let group = group1 {
                self.dataToDisplayForCells.append(group)
            }
            if let group = group2 {
                self.dataToDisplayForCells.append(group)
            }
            if let group = group3 {
                self.dataToDisplayForCells.append(group)
            }
            if let socialGroup = socialGroup {
                self.dataToDisplayForHeader = socialGroup
            }
            
            self.collectionView.reloadData()
        }
    }
    
    
}

extension AppsPageController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppsRootCell else { return UICollectionViewCell() }
        cell.dataToDisplay = dataToDisplayForCells[indexPath.item].feed
        cell.didSelectHandler = { [weak self] (feedResult) in
            let newController = BetterAppDetailController(appId: feedResult.id)
            newController.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(newController, animated: true)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplayForCells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? AppsHeader else { return UICollectionReusableView() }
        header.dataToDisplay = dataToDisplayForHeader
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AppsPageController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
}
