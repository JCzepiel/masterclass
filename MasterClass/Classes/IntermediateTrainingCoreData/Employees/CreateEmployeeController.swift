//
//  CreateEmployeeController.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation
import UIKit

protocol CreateEmployeeControllerDelegate {
    func userAddedNewEmployee(employee: EmployeeEntity)
}

class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeControllerDelegate?
    
    var company: CompanyEntity?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Name"
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Birthday"
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "MM/DD/YYYY"
        return textField
    }()
    
    let employeeTypeSegementedControl: UISegmentedControl = {
        let titles = [EmployeeType.executive.rawValue, EmployeeType.seniorManagement.rawValue, EmployeeType.staff.rawValue]
        let control = UISegmentedControl(items: titles)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.tintColor = .darkBlue
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        
        view.backgroundColor = .darkBlue
        
        setupCancelButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        setupLightBlueBackgroundView(height: 150)
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(birthdayLabel)
        view.addSubview(birthdayTextField)
        view.addSubview(employeeTypeSegementedControl)

        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        birthdayTextField.leadingAnchor.constraint(equalTo: birthdayLabel.trailingAnchor).isActive = true
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        birthdayTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        employeeTypeSegementedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 8).isActive = true
        employeeTypeSegementedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        employeeTypeSegementedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        employeeTypeSegementedControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    @objc fileprivate func handleSave() {
        guard let name = nameTextField.text, let company = company, name != "" else { return }
        
        guard let birthday = birthdayTextField.text, birthday != "" else {

            showError(title: "Blank Birthday", message: "Please enter a birthday")

            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let date = dateFormatter.date(from: birthday) else {
            showError(title: "Invalid Birthday", message: "Please enter a correct birthday")
            return
        }
        
        let employeeType = employeeTypeSegementedControl.titleForSegment(at: employeeTypeSegementedControl.selectedSegmentIndex)
        
        let employee = CoreDataManager.shared.createEmployee(name: name, company: company, birthday: date, employeeType: employeeType)
        
        if let employee = employee {
            dismiss(animated: true, completion: {
                self.delegate?.userAddedNewEmployee(employee: employee)
            })
        } else {
            print("error saving new employee")
        }
    }
    
    fileprivate func showError(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
}
