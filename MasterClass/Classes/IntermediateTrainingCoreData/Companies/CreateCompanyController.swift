//
//  CreateCompanyController.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/22/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit
import CoreData

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

protocol CreateCompanyControllerDelegate {
    func userCreatedCompany(company: CompanyEntity)
    func didEditCompany(company: CompanyEntity)
}

class CreateCompanyController: UIViewController {
    
    var delegate: CreateCompanyControllerDelegate?
    
    var company: CompanyEntity? {
        didSet {
            guard let company = company else { return }
            navigationItem.title = "Edit Company"
            nameTextField.text = company.name
            datePicker.date = company.founded ?? Date()
            
            if let imageData = company.imageData, let hasImage = UIImage(data: imageData) {
                companyImageView.image = hasImage
                
                self.setupCircularImageStyle()
            }
        }
    }
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "select_photo_empty")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTappedImage)))
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.textColor = .black
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Name"
        textField.textColor = .black
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        picker.datePickerMode = .date
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "Create Company"
        
        setupCancelButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        let backgroundView = setupLightBlueBackgroundView(height: 350)
        
        view.addSubview(companyImageView)
        companyImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        companyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        view.addSubview(datePicker)
        datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
    }
    
    fileprivate func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width/2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func userTappedImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    fileprivate func saveCompanyChanges() {
        guard let name = self.nameTextField.text, let company = company else { return }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext

        company.name = name
        company.founded = datePicker.date
        company.setValue(companyImageView.image?.jpegData(compressionQuality: 0.8), forKey: "imageData")

        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didEditCompany(company: company)
            })
        } catch let error {
            print("Error saving = \(error)")
        }
    }
    
    fileprivate func createCompany() {
        guard let name = self.nameTextField.text else { return }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let company = NSEntityDescription.insertNewObject(forEntityName: "CompanyEntity", into: context) as? CompanyEntity else { return }
        
        company.setValue(name, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        company.setValue(companyImageView.image?.jpegData(compressionQuality: 0.8), forKey: "imageData")
        
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.userCreatedCompany(company: company)
            })
            
        } catch let error {
            print("Error saving = \(error)")
        }
    }
}

extension CreateCompanyController: UINavigationControllerDelegate {
    
}

extension CreateCompanyController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        
        companyImageView.image = image
        self.setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
