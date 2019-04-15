//
//  InfoPanels.swift
//  InfoPanel
//
//  Created by Alexander Omelchuk on 03.04.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import CloudKit

class InfoPanels {
    
    var section0:[CKRecord] = []
    var section1:[CKRecord] = []
    var section2:[CKRecord] = []
    
    // MARK: - Получить записи из iCloud
    func getRecords(finishFunction: @escaping ()->()) {
        section0 = []; section1 = []; section2 = []
        
        let predicate = NSPredicate(value: true)
        let publicDataBase = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "InfoPanel", predicate: predicate)
        let groupDescriptor = NSSortDescriptor(key: "group", ascending: false)
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        query.sortDescriptors = [groupDescriptor,nameDescriptor]
        
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil else {
                finishFunction()
                return
            }
            guard let records = records else {
                finishFunction()
                return
            }
            self.sortElement(records: records)
            finishFunction()
        }
    }
    
    // MARK: - Сортировка элементов
    private func sortElement(records: [CKRecord]) {
        for record in records {
            let groupName = record.object(forKey: "group") as? String
            switch groupName {
            case "orange": self.section0.append(record)
            case "green": self.section1.append(record)
            case "blue": self.section2.append(record)
            default: return
            }
        }
    }
    
    // MARK: - Сохрнить картинку в ICloud
    static func saveImageToCloud(_ panel: CKRecord?, image: UIImage?) {
        guard let panel = panel else { return }
        guard let image = image else { return }
        let imageFilePath = NSTemporaryDirectory() + "Snapshot"
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        do {
            try image.jpegData(compressionQuality: 0.5)?.write(to: imageFileURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        let imageAsset = CKAsset(fileURL: imageFileURL)
        panel.setValue(imageAsset, forKey: "image")
        let publicDataBase = CKContainer.default().publicCloudDatabase
        publicDataBase.save(panel) { (_, error) in
            guard error == nil else {return}
            do {
                try FileManager.default.removeItem(at: imageFileURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
}
