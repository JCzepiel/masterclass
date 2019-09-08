//
//  CompaniesController.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/21/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [CompanyEntity]()
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPlusButtonInNavigationBar(selector: #selector(userPressedPlus))
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
                                             UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(handleNestedUpdates))]

        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        
        fetchCompanies()
    }
    
    fileprivate func fetchCompanies() {
        self.companies = CoreDataManager.shared.fetchCompanies()
        self.tableView.reloadData()
    }
    
    @objc fileprivate func handleReset() {
        let indexPathsToRemove = CoreDataManager.shared.deleteAllCompanies(in: companies)
        companies.removeAll()
        tableView.deleteRows(at: indexPathsToRemove, with: .left)
    }
    
    @objc fileprivate func handleDoWork() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            (0...5).forEach { (index) in
                print(index)
                let company = CompanyEntity(context: backgroundContext)
                company.name = String(index)
            }
            
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.fetchCompanies()
                }
            } catch let error {
                print("eror saving = \(error)")
            }
        })
    }
    
    @objc fileprivate func handleDoUpdates() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach({
                    $0.name = "D: \($0.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.fetchCompanies()
                    }
                } catch let error {
                    print("failed to save in background = \(error)")
                }
                
            } catch let error {
                print("error fetching background = \(error)")
            }
        }

    }
    
    @objc fileprivate func handleNestedUpdates() {
        DispatchQueue.global(qos: .background).async {
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            let request: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach({
                    $0.name = "D: \($0.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    
                    DispatchQueue.main.async {
                        
                        do {
                            if CoreDataManager.shared.persistentContainer.viewContext.hasChanges {
                                try CoreDataManager.shared.persistentContainer.viewContext.save()
                            }
                            
                            self.tableView.reloadData()

                        } catch let error {
                            print("failed to save in final save = \(error)")
                        }

                    }
                } catch let error {
                    print("failed to save in privateContext = \(error)")
                }
                
            } catch let error {
                print("fail to private fetch = \(error)")
            }
        }
    }
    
    
    @objc fileprivate func userPressedPlus() {
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navigationController = CustomNavigationController(rootViewController: createCompanyController)
        self.present(navigationController, animated: true, completion: nil)
    }
}

