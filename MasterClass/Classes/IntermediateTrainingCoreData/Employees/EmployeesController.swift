//
//  EmployeesController.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation
import UIKit

class EmployeesController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    var allEmployees = [[EmployeeEntity]]()
    
    var employeeTypes = [EmployeeType.executive.rawValue, EmployeeType.seniorManagement.rawValue, EmployeeType.staff.rawValue]
    
    var company: CompanyEntity? {
        didSet {
            guard let company = company else { return }
            
            navigationItem.title = company.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.backgroundColor = .darkBlue
        
        setupPlusButtonInNavigationBar(selector: #selector(userPressedPlus))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchEmployees()
    }
    
    fileprivate func fetchEmployees() {
        guard let employessFromCoreData = company?.employees?.allObjects as? [EmployeeEntity] else { return }
        
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(employessFromCoreData.filter({ $0.type == employeeType }))
        }
        
        tableView.reloadData()
    }
    
    @objc fileprivate func userPressedPlus() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navigationController = CustomNavigationController(rootViewController: createEmployeeController)
        present(navigationController, animated: true, completion: nil)
    }
}

class JamesLabel: UILabel {
    let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
}

extension EmployeesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = JamesLabel()
        label.numberOfLines = 0
        label.text = employeeTypes[section]
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = .lightBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        if let birthday = employee.employeeInformation?.birthday, let name = employee.fullName {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateFormatter.dateStyle = .medium
            let birthdayText = dateFormatter.string(from: birthday)
            cell.textLabel?.text = name + ", Birthday: " + birthdayText
        } else if let name = employee.fullName {
            cell.textLabel?.text = name
        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = .white
        return cell
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    func userAddedNewEmployee(employee: EmployeeEntity) {
        guard let newEmployeeType = employee.type, let section = employeeTypes.index(of: newEmployeeType) else { return }
        
        let row = allEmployees[section].count - 1
        let newIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [newIndexPath], with: .middle)
    }
}
