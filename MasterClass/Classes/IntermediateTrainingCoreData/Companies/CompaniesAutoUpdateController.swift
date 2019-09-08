//
//  CompaniesAutoUpdateController.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/27/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    lazy var fetchedResultsController: NSFetchedResultsController<CompanyEntity> = {
        let request: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        
        do {
            try frc.performFetch()

        } catch let error {
            print("fetch error = \(error)")
        }
        
        frc.delegate = self
        
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Company Auto Updates"
        
        tableView.backgroundColor = .darkBlue

        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack)),
                                             UIBarButtonItem(title: "D", style: .plain, target: self, action: #selector(handleDelete))]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        self.refreshControl = refreshControl
        
        setupPlusButtonInNavigationBar(selector: #selector(userPressedPlus))
    }
    
    @objc fileprivate func userPressedPlus() {
        let createCompanyController = CreateCompanyController()
        //createCompanyController.delegate = self
        let navigationController = CustomNavigationController(rootViewController: createCompanyController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func handleAdd() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = CompanyEntity(context: context)
        company.name = "Faro"

        do {
            try context.save()
        } catch let error {
            print("error saving new = \(error)")
        }
    }
    
    @objc fileprivate func handleRefresh() {
        CoreDataAPIService.shared.downloadCompaniesFromServer()
        refreshControl?.endRefreshing()
    }
    
    @objc fileprivate func handleDelete() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

        do {
            let companies = try context.fetch(request)
            companies.forEach { (company) in
                context.delete(company)
            }
            
            try context.save()
            
        } catch let error {
            print("error companiesWithB = \(error)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = JamesLabel()
        label.backgroundColor = .lightBlue
        //label.text = fetchedResultsController.sectionIndexTitles[section] // this causes a crash wtf
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CompanyCell else { return UITableViewCell() }
        let company = fetchedResultsController.object(at: indexPath)
        cell.company = company
        cell.backgroundColor = .tealColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = EmployeesController()
        let company = fetchedResultsController.object(at: indexPath)
        viewController.company = company
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

/// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html
extension CompaniesAutoUpdateController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        //TODO: WHY ISNT THIS BEING CALLED WTFFFFF
        return "WTF"
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // should use a switch
        if type == .insert {
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .middle)
            }
        } else if type == .delete {
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // Below is from apple doc
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert:
//            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//        case .delete:
//            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//        case .move:
//            break
//        case .update:
//            break
//        }
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
//        case .update:
//            tableView.reloadRows(at: [indexPath!], with: .fade)
//        case .move:
//            tableView.moveRow(at: indexPath!, to: newIndexPath!)
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
}
