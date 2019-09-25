//
//  CloudService.swift
//  InfoPanelExtension
//
//  Created by Александр Омельчук on 23.09.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import Foundation
import CloudKit

class CloudService {
    
    var panelsArrey = [CKRecord]()
    
    //MARK: - Get panels wrom ICloud
    
    func getPanels(finishFunc: @escaping ()->()) {
        let predicate = NSPredicate(value: true)
        let publicDataBase = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "InfoPanels", predicate: predicate)
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        query.sortDescriptors = [nameDescriptor]
        
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let records = records else { return }
            for record in records {
                self.panelsArrey.append(record)
            }
            finishFunc()
        }
    }
    
    
}
