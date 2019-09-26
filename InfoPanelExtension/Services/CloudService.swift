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
    
    var panelsArrey = [Panel]()
    
    //MARK: - Get panels wrom ICloud
    
    func getPanels(finishFunc: @escaping ()->()) {
        
        panelsArrey = []
        
        let predicate = NSPredicate(value: true)
        let publicDataBase = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "InfoPanels", predicate: predicate)
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let groupDescriptor = NSSortDescriptor(key: "group", ascending: false)
        query.sortDescriptors = [groupDescriptor, nameDescriptor]
        
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let records = records else { return }
            for record in records {
                self.panelsArrey.append(Panel(cloudRecord: record))
            }
            finishFunc()
        }
    }
    
    
}

    //MARK: - Panel struct

struct Panel {
    
    var name: String?
    var address: String?
    var orient: Orient
    var group: Group?
    
    enum Orient {
        case vertical
        case horisont
    }
    enum Group {
        case blue
        case green
        case orange
    }
    
    init (cloudRecord: CKRecord) {
        
        self.name = cloudRecord.object(forKey: "name") as? String
        self.address = cloudRecord.object(forKey: "address") as? String
        switch cloudRecord.object(forKey: "group") as? String {
        case "blue":
            self.group = .blue
        case "green":
            self.group = .green
        default:
            self.group = .orange
        }
        
        if cloudRecord.object(forKey: "orient") as? String == "h" {
            self.orient = .horisont
        } else {
            self.orient = .vertical
        }
    }
}
