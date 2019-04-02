//
//  StartViewController.swift
//  DO Panel
//
//  Created by Alexander Omelchuk on 30.03.2019.
//  Copyright © 2019 Alexander Omelchuk. All rights reserved.
//

import UIKit
import CloudKit

class StartViewController: UITableViewController {
    
    var infoPanels: [CKRecord] = []
    var currentPanel: CKRecord?
    let publicDataBase = CKContainer.default().publicCloudDatabase // Публичный контейнер с записями

    override func viewDidLoad() {
        super.viewDidLoad()
        getCloudRecords()
    }
    
    //MARK: - Получить данные из iCloud
    func getCloudRecords() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "InfoPanel", predicate: predicate)
        let groupDescriptor = NSSortDescriptor(key: "group", ascending: false)
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        query.sortDescriptors = [groupDescriptor,nameDescriptor]
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil else {return}
            guard let records = records else {return}
            self.infoPanels = records
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoPanels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let infoPanel = infoPanels[indexPath.row]
        cell.textLabel?.text = infoPanel.object(forKey: "name") as? String
        cell.imageView?.image = UIImage(named: (infoPanel.object(forKey: "group") as? String)!)
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPanel = infoPanels[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "Control", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Control" {
            guard let destination = segue.destination as? ViewController else {return}
            destination.panel = currentPanel
        }
    }

    
}
