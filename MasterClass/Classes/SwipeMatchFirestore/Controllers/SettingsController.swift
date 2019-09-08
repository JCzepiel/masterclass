//
//  SettingsController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 1/4/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    lazy var image1Button = createButton(selector: #selector(handlePhotoPressed))
    lazy var image2Button = createButton(selector: #selector(handlePhotoPressed))
    lazy var image3Button = createButton(selector: #selector(handlePhotoPressed))
    
    lazy var header: UIView = {
        let header = UIView()
        
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        return header
    }()
    
    var user: SwipeMatchFirestoreUser?
    
    var delegate: SettingsControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }

    // MARK: - Tableview
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        
        let headerLabel = HeaderLabel()
        
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300.0
        }
        
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChanged), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChanged), for: .valueChanged)
            
            let minAge = user?.minSeekingAge ?? SwipeMatchFirestoreUser.defaultMinAge
            let maxAge = user?.maxSeekingAge ?? SwipeMatchFirestoreUser.defaultMaxAge
            
            ageRangeCell.minLabel.text = "Min \(minAge)"
            ageRangeCell.minSlider.value = Float(minAge)
            ageRangeCell.maxLabel.text = "Max \(maxAge)"
            ageRangeCell.maxSlider.value = Float(maxAge)

            return ageRangeCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChanged), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChanged), for: .editingChanged)
        case 3:
            cell.textField.keyboardType = .numberPad
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(handleAgeChanged), for: .editingChanged)

        default:
            cell.textField.placeholder = "Enter Bio"
        }
        
        return cell
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
        guard let customPicker = picker as? CustomImagePickerController, let buttonPressed = customPicker.imageButton else {
            dismiss(animated: true)
            return
        }
        
        buttonPressed.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = image?.jpegData(compressionQuality: 0.75) else { return }
        ref.putData(uploadData, metadata: nil) { (storageMetadata, error) in
            if let error = error {
                hud.dismiss()
                print("failed putting image with error = \(error)")
                return
            }
            
            
            // TODO: MAKE MORE EFFICENT - ONLY DOWNLOAD URL WHEN USE CLICKS SAVE!??!
            ref.downloadURL(completion: { [unowned self] url, image in
                hud.dismiss()

                if let error = error {
                    print("failed downloading image url with error = \(error)")
                    return
                }
                
                if buttonPressed == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if buttonPressed == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else if buttonPressed == self.image3Button {
                    self.user?.imageUrl3 = url?.absoluteString
                }

            })
        }
    }
    
    // MARK: - Fileprivate
    
    fileprivate func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)), UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))]
    }
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { [unowned self] user, error in
            if let error = error {
                print("Error fetching user in SettingsController = \(error)")
                return
            }
            
            self.user = user
            self.loadUserPhotos()
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        if  let imageUrl1String = user?.imageUrl1, let imageUrl1 = URL(string: imageUrl1String) {
            SDWebImageManager.shared().loadImage(with: imageUrl1, options: .continueInBackground, progress: nil) { [unowned self] image, _, _, _, _, _ in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        

        
        if let imageUrl2String = user?.imageUrl2, let imageUrl2 = URL(string: imageUrl2String) {
            SDWebImageManager.shared().loadImage(with: imageUrl2, options: .continueInBackground, progress: nil) { [unowned self] image, _, _, _, _, _ in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        

        
        if let imageUrl3String = user?.imageUrl3, let imageUrl3 = URL(string: imageUrl3String) {
            SDWebImageManager.shared().loadImage(with: imageUrl3, options: .continueInBackground, progress: nil) { [unowned self] image, _, _, _, _, _ in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        

    }
    
    @objc fileprivate func handlePhotoPressed(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.imageButton = button
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc fileprivate func handleNameChanged(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChanged(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChanged(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    @objc fileprivate func handleMinAgeChanged(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        guard let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeRangeCell else { return }
        let minSliderIntValue = Int(slider.value)
        let currentMaxIntValue = Int(ageRangeCell.maxSlider.value)

        if minSliderIntValue <= currentMaxIntValue {
            ageRangeCell.minLabel.text = "Min \(minSliderIntValue)"
        } else {
            ageRangeCell.minSlider.value = ageRangeCell.maxSlider.value
        }

        self.user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxAgeChanged(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        guard let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeRangeCell else { return }
        let maxSliderIntValue = Int(slider.value)
        let currentMinIntValue = Int(ageRangeCell.minSlider.value)

        if maxSliderIntValue >= currentMinIntValue {
            ageRangeCell.maxLabel.text = "Max \(Int(slider.value))"
        } else {
            ageRangeCell.maxSlider.value = ageRangeCell.minSlider.value
        }

        self.user?.maxSeekingAge = Int(slider.value)

    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving..."
        hud.show(in: view)

        let documentData: [String: Any] = ["uid": uid,
                                           "fullName": user?.name ?? "",
                                           "imageUrl1": user?.imageUrl1 ?? "",
                                           "imageUrl2": user?.imageUrl2 ?? "",
                                           "imageUrl3": user?.imageUrl3 ?? "",
                                           "age": user?.age ?? -1,
                                           "profession": user?.profession ?? "",
                                           "minSeekingAge": user?.minSeekingAge ?? -1,
                                           "maxSeekingAge": user?.maxSeekingAge ?? -1]
        Firestore.firestore().collection("users").document(uid).setData(documentData) { [unowned self] error in
            hud.dismiss()
            
            if let error = error {
                print("error saving user data with error = \(error)")
                return
            }
            
            self.dismiss(animated: true, completion: {
                self.delegate?.didSaveSettings()
            })
        }
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true) {
            
        }
    }
}
