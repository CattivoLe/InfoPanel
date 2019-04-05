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
    
    static var section0:[CKRecord] = []
    static var section1: [CKRecord] = []
    static var section2:[CKRecord] = []
    
    static func getRecords() {
        let predicate = NSPredicate(value: true)
        let publicDataBase = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "InfoPanel", predicate: predicate)
        let groupDescriptor = NSSortDescriptor(key: "group", ascending: false)
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        query.sortDescriptors = [groupDescriptor,nameDescriptor]
        
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil else {return}
            guard let records = records else {return}
            for record in records {
                let groupName = record.object(forKey: "group") as? String
                switch groupName {
                case "orange": self.section0.append(record)
                case "green": self.section1.append(record)
                case "blue": self.section2.append(record)
                default:
                    return
                }
            }
        }
    }
    
    
}
