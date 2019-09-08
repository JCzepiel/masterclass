//
//  SwipeMatchFirestoreHomeController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 12/17/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SwipeMatchFirestoreHomeController: UIViewController, SettingsControllerDelegate, SwipeMatchFirestoreLoginControllerDelegate, CardViewDelegate {
    
    // MARK: - Properties

    let topStackView = HomeTopControlsStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    var lastFetchedUser: SwipeMatchFirestoreUser?
    
    var user: SwipeMatchFirestoreUser?
    
    var topCardView: CardView?
    
    var swipes = [String: Int]()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is slightly different than the tutorial
        if let settingsButton = topStackView.arrangedSubviews[0] as? UIButton {
            settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        }
        if let paginationButton = buttonsStackView.arrangedSubviews[0] as? UIButton {
            paginationButton.addTarget(self, action: #selector(handlePaging), for: .touchUpInside)
        }
        
        if let registerButton = buttonsStackView.arrangedSubviews[1] as? UIButton {
            registerButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        }
        
        if let registerButton = buttonsStackView.arrangedSubviews[3] as? UIButton {
            registerButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        }
        
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navigationController = UINavigationController(rootViewController: registrationController)
            present(navigationController, animated: true)
        }

    }
    
    // MARK: - Fileprivate
    
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navigationController = UINavigationController(rootViewController: settingsController)
        present(navigationController, animated: true)
    }
    
    @objc fileprivate func handlePaging() {
        // Remove all remaining cards from the view. This fixes a visual bug that happens when there are no cards on the screen
        // But the side effect is that it will remove any cards you havent swiped way yet. I will keep this for now
        cardsDeckView.subviews.forEach { $0.removeFromSuperview() }
        
        // Get user then refresh cards
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleRegister() {
        let registerController = RegistrationController()
        present(registerController, animated: true)
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = 0.8
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle
        rotationAnimation.duration = 0.8
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "handleLikeAnimation")
        cardView?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        CATransaction.commit()
    }
    
    fileprivate func saveSwipeToFirestore(liked: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUID = topCardView?.cardViewModel?.uid else { return }
        let documentData: [String: Any] = [cardUID: liked]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshop, error) in
            if let error = error {
                print("error getting swipe = \(error)")
                return
            }
            
            if snapshop?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (error) in
                    if let error = error {
                        print("error saving swipe = \(error)")
                        return
                    }
                    
                    print("saved swipe!")
                    if liked {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (error) in
                    if let error = error {
                        print("error saving swipe = \(error)")
                        return
                    }
                    
                    print("saved swipe!")
                    if liked {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                    
                }
            }
        }
        

    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapShop, error) in
            if let error = error {
                print("failed to fetch document for card user = \(error)")
                return
            }
            
            guard let data = snapShop?.data() else { return }
            
            guard let currentUID = Auth.auth().currentUser?.uid else { return }
            
            let hasMatch = data[currentUID] as? Int == 1
            if hasMatch {
                print("has matched")

                self.presentMatchView(cardUID: cardUID)
            }
        }
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    @objc fileprivate func handleLike() {
        saveSwipeToFirestore(liked: true)
        
        performSwipeAnimation(translation: UIScreen.main.bounds.width * 1.75, angle: 15 * CGFloat.pi / 180)
    }
    
    @objc fileprivate func handleDislike() {
        saveSwipeToFirestore(liked: false)

        performSwipeAnimation(translation: -UIScreen.main.bounds.width, angle: -15 * CGFloat.pi / 180)
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor , bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func setupCardFromUser(user: SwipeMatchFirestoreUser) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardView.delegate = self
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { user, error in
            if let error = error {
                print("Error fetching current user in homeController = \(error)")
                return
            }
            
            self.user = user
            self.fetchSwipes()
        }
    }
    
    fileprivate func fetchSwipes() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(currentUID).getDocument { (snapShot, error) in
            if let error = error {
                print ("failed fetching swipes with error = \(error as Any)")
                return
            }
            
            guard let data = snapShot?.data() as? [String: Int] else {
                // Ftch users even if no swipes...
                self.fetchUsersFromFirestore()
                return
            }
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    fileprivate func fetchUsersFromFirestore() {
        //let query = Firestore.firestore().collection("users")
        //let query = Firestore.firestore().collection("users").whereField("age", isEqualTo: 2018)
        //let query = Firestore.firestore().collection("users").whereField("age", isLessThan: 31).whereField("age", isGreaterThan: 21)
        //let query = Firestore.firestore().collection("users").whereField("friends", arrayContains: "Chris")
        //let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: user?.minSeekingAge ?? SwipeMatchFirestoreUser.defaultMinAge).whereField("age", isLessThanOrEqualTo: user?.maxSeekingAge ?? SwipeMatchFirestoreUser.defaultMaxAge)
        topCardView = nil
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users..."
        hud.show(in: view)
        
        query.getDocuments { [unowned self] snapshot, error in
            hud.dismiss()

            if let error = error {
                print("Failed fetching users from firestore with error: \(error)")
                return
            }
            
            // Set up a linkedlist for CardViews
            
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ [weak self] document in
                guard let self = self else { return }
                let userDictionary = document.data()
                let user = SwipeMatchFirestoreUser(dictionary: userDictionary)
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                //let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                if isNotCurrentUser /*&& hasNotSwipedBefore*/ {
                    self.lastFetchedUser = user
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    /// SettingsControllerDelegate conformance
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    /// LoginControllerDelegate conformance
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    /// CardViewDelegate conformance
    func didTapMoreInfo(cardViewModel: CardViewModel?) {
        let userInformationController = UserDetailsController()
        userInformationController.cardViewModel = cardViewModel
        present(userInformationController, animated: true)
    }
    
    func didRemoveCard(cardView: CardView, withLiked: Bool) {
        saveSwipeToFirestore(liked: withLiked)
        topCardView?.removeFromSuperview()
        topCardView = topCardView?.nextCardView
    }
}

