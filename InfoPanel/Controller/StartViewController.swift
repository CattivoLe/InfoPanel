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
    
    var currentPanel: CKRecord?

    override func viewDidLoad() {
        super.viewDidLoad()
        Cloud.getRecords(viewController: self)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cloud.infoPanels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let infoPanel = Cloud.infoPanels[indexPath.row]
        cell.setValue(currentPanel: infoPanel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPanel = Cloud.infoPanels[indexPath.row]
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
