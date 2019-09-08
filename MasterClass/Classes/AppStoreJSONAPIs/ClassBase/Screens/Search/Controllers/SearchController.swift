//
//  SearchController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit
import SDWebImage

class SearchController: BaseListController {
    
    // MARK: - Properties

    fileprivate let cellId = "cellId"
    
    fileprivate var appResults = [SearchDisplayable]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate var timer: Timer?
    
    fileprivate let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white
        
        collectionView.addSubview(emptyLabel)
        emptyLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 32).isActive = true
        emptyLabel.centerXInSuperview()
        
        setupSearchBar()
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func fetchApps() {
        AppStoreAPI.shared.fetchApps(searchTerm: "Twitter") { (result, error) in
            if let error = error {
                print(error)
            }

            if let result = result {
                self.appResults = result.results
            }
        }
        
        /*SteamAPI.shared.fetchGames { (result, error) in
            if let error = error {
                print(error)
            }

            if let result = result {
                self.appResults = result.games
            }
        }*/
    }
}

// MARK: - CollectionView Delegate

extension SearchController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = appResults[indexPath.item].trackId
        
        let newController = BetterAppDetailController(appId: String(appId))
        navigationController?.pushViewController(newController, animated: true)
    }
}

// MARK: - CollectionView DataSource

extension SearchController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchResultCell else { return UICollectionViewCell() }
        cell.appResult = appResults[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyLabel.isHidden = appResults.count != 0
        return appResults.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            JCProgressView.shared.showProgressView(in: self.view, backgroundTransparent: true)
            AppStoreAPI.shared.fetchApps(searchTerm: searchText) { (result, error) in
                
                DispatchQueue.main.async {
                    JCProgressView.shared.hideProgressView(in: self.view)
                }

                if let error = error {
                    print(error)
                }
                
                if let result = result {
                    self.appResults = result.results
                }
            }
        })
    }
}
