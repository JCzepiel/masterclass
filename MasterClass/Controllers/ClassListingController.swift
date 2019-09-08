//
//  ClassListingController.swift
//  MasterClass
//
//  Created by James Czepiel on 2/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit
import Firebase

class ClassListingController: UIViewController {
    
    let classCellID = "classCellID"
    
    let viewModel = ClassListingViewModel()
    
    lazy var classListingCollectionView: UICollectionView = {
        let layout = ClassListingLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadClassesData { [weak self] in
            self?.classListingCollectionView.reloadData()
        }
        
        setupLayout()
    }

    fileprivate func setupLayout() {
        view.addSubview(classListingCollectionView)
        
        classListingCollectionView.register(ClassListingCell.self, forCellWithReuseIdentifier: classCellID)
        
        classListingCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        classListingCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        classListingCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        classListingCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ClassListingController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfClasses()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: classCellID, for: indexPath) as? ClassListingCell, let classModel = viewModel.classAtIndex(index: indexPath.row) else { return UICollectionViewCell () }
        
        cell.classNameLabel.text = classModel.title
        cell.classDescriptionLabel.text = classModel.description
        cell.backgroundColor = classModel.isImplemented ? UIColor.rgb(red: 0, green: 255, blue: 0, alpha: 0.7) : UIColor.rgb(red: 255, green: 0, blue: 0, alpha: 0.7)
        
        cell.doStupidAnimation()
        
        return cell
    }
}

extension ClassListingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // We are setting height to be arbitrarily high since the Cell will resize itself in ClassListingCell.swift preferredLayoutAttributesFitting
        // Note: Setting height to low will cause AutoLayout errors in the console, despite the App looking fine
        return .init(width: view.frame.width, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension ClassListingController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let classModel = viewModel.classAtIndex(index: indexPath.row) else { return }
        
        if classModel.title == "AnimatedCircle" {
            let newController = AnimatedCircleViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        }  else if classModel.title == "AnimationsWithConstraints" {
            let newController = AnimationsWithConstraintsViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        }  else if classModel.title == "Appstore" {
            let layout = UICollectionViewFlowLayout()
            let newController = FeaturedAppsController(collectionViewLayout: layout)
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "Audible" {
            // Audible usually starts off with MainNavigationController, like below, but for now lets just load the main controller for it
            //window?.rootViewController = MainNavigationController()
            let newController = AudibleLoginController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "AutoTextViewSizing" {
            let newController = AutoTextViewSizingViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "CADisplayLink" {
            let newController = CADisplayLinkViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "ChainedAnimations" {
            let newController = ChainedAnimationsViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "FacebookLiveStream" {
            let newController = FacebookLiveStreamViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "FacebookPopup" {
            let newController = FacebookPopupViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "FacebookShimmer" {
            let newController = FacebookShimmerViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "FaceDetection" {
            let newController = FaceDetectionViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "GroupedMessages" {
            let newController = GroupedMessagesViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "MagicalGrid" {
            let newController = MagicalGridViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "Twitter" {
            let newController = HomeDatasourceController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "UIViewPropertyAnimatorBasics" {
            let newController = UIViewPropertyAnimatorBasicsViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "Youtube" {
            let layout = UICollectionViewFlowLayout()
            let newController = YoutubeHomeController(collectionViewLayout: layout)
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "SwipeMatchFirestore" {
            let newController = SwipeMatchFirestoreHomeController()
            navigationController?.pushViewController(newController, animated: true)
            return
        }  else if classModel.title == "DrawSomething" {
            let newController = DrawSomethingViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "RetainCycleInstruments" {
            let newController = RetainCycleInstrumentsViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "StretchyHeader" {
            let layout = StretchyHeaderLayout()
            let newController = StretchyHeaderController(collectionViewLayout: layout)
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "InteractiveSlideOutMenuLeftRight" {
            let newController = MainViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "InteractiveSlideOutMenuUpDown" {
            let newController = UpDownSlideMainViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "CustomNavigationControllerAnimation" {
            let newController = WhiteViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "IntermediateTrainingCoreData" {
            let newController = CompaniesAutoUpdateController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "AppStoreJSONAPIs" {
            let newController = AppStoreBridgeController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "CollectionViewStuff" {
            let newController = CollectionViewStuffController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "CircularLoadingAnimation" {
            let newController = CLAViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "BottomPopUpScreenTest" {
            let newController = BottomPopUpScreenTestViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "CubeAnimation" {
            let newController = CubeAnimationViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        } else if classModel.title == "TextExclusion" {
            let newController = TextExclusionViewController()
            navigationController?.pushViewController(newController, animated: true)
            return
        }
        
        let newController = BlankViewController()
        newController.controllerTitle = classModel.title
        navigationController?.pushViewController(newController, animated: true)
    }
}


