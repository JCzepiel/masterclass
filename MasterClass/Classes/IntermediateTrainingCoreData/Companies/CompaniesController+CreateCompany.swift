//
//  CompaniesController+CreateCompany.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

extension CompaniesController: CreateCompanyControllerDelegate {
    func didEditCompany(company: CompanyEntity) {
        guard let row = companies.index(of: company) else { return }
        let reloadIndexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func userCreatedCompany(company: CompanyEntity) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
