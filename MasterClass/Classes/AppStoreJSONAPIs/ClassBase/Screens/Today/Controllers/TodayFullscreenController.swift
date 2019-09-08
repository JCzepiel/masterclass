//
//  TodayFullscreenController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/26/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class TodayFullScreenController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate let descriptionCellId = "descriptionCellId"
    fileprivate let imageCellId = "imageCellId"
    
    var dismissHandler: (() -> ())?

    var dataToDisplay: TodayModel?
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        return button
    }()
    
    let floatingContainerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This makes the drag to dismiss animated a little smoother since the curved sides matches the curve sides of the TodayCell. It makes it look weird when this page is fullscreen though.
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TodayFullscreenDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
        tableView.register(TodayFullscreenImageCell.self, forCellReuseIdentifier: imageCellId)

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        
        setupCloseButton()
        
        setupFloatingControls()
    }
    
    fileprivate func setupFloatingControls() {
        floatingContainerView.layer.cornerRadius = 16
        floatingContainerView.clipsToBounds = true
        view.addSubview(floatingContainerView)
        //let bottomPadding = UIApplication.shared.statusBarFrame.height
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90, right: 16), size: .init(width: 0, height: 90))
        
        let blueVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blueVisualEffectView)
        blueVisualEffectView.fillSuperview()
        
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = #imageLiteral(resourceName: "garden")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.constrainWidth(constant: 68)
        imageView.constrainHeight(constant: 68)
        
        let headerLabel = UILabel(text: "Header", font: .boldSystemFont(ofSize: 16))
        let descriptionLabel = UILabel(text: "Buy me now!", font: .systemFont(ofSize: 14))
        let getButton = UIButton(title: "GET")
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        let verticalLabelStackView = VerticalStackView(arrangedSubviews: [headerLabel, descriptionLabel], spacing: 0)

        let stackView = UIStackView(arrangedSubviews: [imageView, verticalLabelStackView, getButton])
        stackView.spacing = 16
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }
    
    @objc fileprivate func handleTap() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = .init(translationX: 0, y: -130)
        }, completion: nil)
    }
    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 12), size: .init(width: 80, height: 38))
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        floatingContainerView.isHidden = true
        dismissHandler?()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
        
        let translationY = -90 - UIApplication.shared.statusBarFrame.height
        let transform = scrollView.contentOffset.y > 200 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = transform
        }, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension TodayFullScreenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: imageCellId, for: indexPath) as? TodayFullscreenImageCell else { return UITableViewCell() }
            cell.todayCell.dataToDisplay = dataToDisplay
            cell.todayCell.layer.cornerRadius = 0
            cell.todayCell.layer.shadowOpacity = 0
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.cellHeight
        } else if indexPath.row == 1 {
            return UITableView.automaticDimension
        }
        
        return 0
    }
}

// MARK: - UITableViewDelegate

extension TodayFullScreenController: UITableViewDelegate {
    
}
