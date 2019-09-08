//
//  CoreDataAPIService.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/28/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation
import CoreData

class CoreDataAPIService {
    
    static let shared = CoreDataAPIService()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("failed to download companies = \(error)")
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let companies = try decoder.decode([Company].self, from: data)
                
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                companies.forEach({ (aCompany) in
                    
                    let coreDataCompany = CompanyEntity(context: privateContext)
                    coreDataCompany.name = aCompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    coreDataCompany.founded = dateFormatter.date(from: aCompany.founded)
                    
                    aCompany.employees?.forEach({ (aEmployee) in
                        let coreDataEmployee = EmployeeEntity(context: privateContext)
                        coreDataEmployee.fullName = aEmployee.name
                        coreDataEmployee.type = aEmployee.type
                        
                        let employeeInformation = EmployeeInformationEntity(context: privateContext)
                        employeeInformation.birthday = dateFormatter.date(from: aEmployee.birthday)
                        
                        coreDataEmployee.employeeInformation = employeeInformation
                        
                        coreDataEmployee.company = coreDataCompany
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let error {
                        print("error saving new json to coredata = \(error)")
                    }
                })
                
            } catch let error {
                print("failed to decode = \(error)")
            }
        }.resume()
    }
}

struct Company: Decodable {
    let name: String
    let photoUrl: String
    let founded: String
    let employees: [Employee]?
}

struct Employee: Decodable {
    let name: String
    let birthday: String
    let type: String
}
