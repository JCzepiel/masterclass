//
//  CoreDataManager.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/22/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntermediateTrainingModels")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed = \(error)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [CompanyEntity] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CompanyEntity>(entityName: "CompanyEntity")
        
        do {
            let companyEntities = try context.fetch(fetchRequest)
            return companyEntities
            
        } catch let error {
            print("Error fetching = \(error)")
            return []
            
        }
    }
    
    func fetchEmployees() -> [EmployeeEntity] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            let employeeEntities = try context.fetch(fetchRequest)
            return employeeEntities
            
        } catch let error {
            print("Error fetching = \(error)")
            return []
            
        }
    }
    
    func deleteAllCompanies(in companies: [CompanyEntity]) -> [IndexPath] {
        let managedContext = persistentContainer.viewContext
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: CompanyEntity.fetchRequest())
        let deleteRequestEmployees = NSBatchDeleteRequest(fetchRequest: EmployeeEntity.fetchRequest())

        do {
            try managedContext.execute(deleteRequest)
            try managedContext.execute(deleteRequestEmployees)

            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                indexPathsToRemove.append(IndexPath(row: index, section: 0))
            }
            
            return indexPathsToRemove
            
        } catch let error {
            print("Error deleting all = \(error)")
            return []
        }
    }
    
    func createEmployee(name: String, company: CompanyEntity, birthday: Date, employeeType: String?) -> EmployeeEntity? {
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "EmployeeEntity", into: context) as? EmployeeEntity
        employee?.fullName = name
        employee?.type = employeeType
        
        employee?.company = company
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformationEntity", into: context) as? EmployeeInformationEntity
        employeeInformation?.birthday = birthday

        employee?.employeeInformation = employeeInformation
        
        do {
            try context.save()
            return employee
        } catch let error {
            print("Error saving employee = \(error)")
            return nil
        }
    }
}
