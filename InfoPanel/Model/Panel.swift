//
//  Panel.swift
//  InfoPanel
//
//  Created by Alexander Omelchuk on 15.04.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import Foundation
import CloudKit

struct Panel {
    
    let name: String?
    let address: String?
    let notes: String?
    let orient: Orient?
    let image: CKAsset?
    let group: Group?
    
    enum Orient {
        case vertical
        case horisontal
    }
    enum Group {
        case orange
        case green
        case blue
    }
    
    init(cloud record: CKRecord) {
        self.name = record.object(forKey: "name") as? String
        self.address = record.object(forKey: "address") as? String
        self.notes = record.object(forKey: "notes") as? String
        self.image = record.object(forKey: "image") as? CKAsset
        
        switch record.object(forKey: "orient") as? String {
        case "v":
            self.orient = .vertical
        default:
            self.orient = .horisontal
        }
        
        switch record.object(forKey: "group") as? String {
        case "orange":
            self.group = .orange
        case "green":
            self.group = .green
        default:
            self.group = .blue
        }
    }
    
    
}

