//
//  MusicController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 5/2/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class MusicController: BaseListController {
    
    fileprivate let cellId = "cellId"
    fileprivate let footerId = "footerId"
    fileprivate var requestOffset = 0
    fileprivate var isPaginating = false
    fileprivate var isDonePaginating = false

    var dataToDisplay: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(MusicTrackCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        fetchData()
    }
    
    fileprivate func fetchData() {
        AppStoreAPI.shared.fetchMusic(withOffset: requestOffset, searchTerm: "taylorswift") { (result, error) in
            if let error = error {
                print("failed music search \(error)")
                return
            }
            
            guard let result = result else { return }
            
            if result.resultCount == 0 {
                self.isDonePaginating = true
            }
            
            self.dataToDisplay.append(contentsOf: result.results)
            
            self.requestOffset = self.requestOffset + result.resultCount
            
            DispatchQueue.main.async {
                self.isPaginating = false
                self.collectionView.reloadData()
            }
        }
    }
}

extension MusicController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MusicTrackCell else { return UICollectionViewCell ()}
        cell.dataToDisplay = dataToDisplay[indexPath.item]
        
        if indexPath.item == dataToDisplay.count - 1 && !isPaginating {
            isPaginating = true
            fetchData()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 80
        
        return CGSize(width: view.frame.width, height: height)
    }
}

extension MusicController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
