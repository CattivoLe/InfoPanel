//
//  Cloud.swift
//  InfoPanel
//
//  Created by Alexander Omelchuk on 03.04.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import CloudKit

class Cloud {
    
    static var infoPanels: [CKRecord] = []
    
    static func getRecords(viewController: UITableViewController) {
        let predicate = NSPredicate(value: true)
        let publicDataBase = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "InfoPanel", predicate: predicate)
        let groupDescriptor = NSSortDescriptor(key: "group", ascending: false)
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        query.sortDescriptors = [groupDescriptor,nameDescriptor]
        
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil else {return}
            guard let records = records else {return}
            Cloud.infoPanels = records
            DispatchQueue.main.async {
                viewController.tableView.reloadData()
            }
        }
    }
    
    
}
