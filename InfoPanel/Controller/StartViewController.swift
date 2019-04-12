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
    
    var buttonSection0 = UIButton()
    var buttonSection1 = UIButton()
    var buttonSection2 = UIButton()
    
    var collapsedSection0 = false
    var collapsedSection1 = false
    var collapsedSection2 = false
    
    var currentPanel: CKRecord?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        refreshControl = UIRefreshControl()
        Cloud.getRecords(tableView: self.tableView, refresh: refreshControl)
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        Cloud.getRecords(tableView: self.tableView, refresh: refreshControl)
        tableView.reloadSections(IndexSet(0...2), with: .automatic)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return collapsedSection0 ? Cloud.section0.count : 0
        case 1: return collapsedSection1 ? Cloud.section1.count : 0
        case 2: return collapsedSection2 ? Cloud.section2.count : 0
        default:
            return 0
        }
    }
    
    // MARK: - Header settings
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        let label = UILabel(frame: CGRect(x: 180, y: 40, width: UIScreen.main.bounds.width, height: 60))
        let image = UIImageView(frame: CGRect(x: 20, y: 30, width: 140, height: 79))
        label.font = label.font.withSize(25)
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        view.addSubview(label)
        view.addSubview(image)
        switch section {
        case 0:
            label.text = NSLocalizedString("Class", comment: "")
            image.image = UIImage(named: "orange")
            label.textColor = #colorLiteral(red: 0.9032962322, green: 0.3431209326, blue: 0.02910011634, alpha: 1)
            view.addSubview(buttonSection0)
            buttonSection0.frame = view.frame
            buttonSection0.addTarget(self, action: #selector(self.hederTapped0), for: .touchUpInside)
        case 1:
            label.text = NSLocalizedString("Lobby", comment: "")
            image.image = UIImage(named: "green")
            label.textColor = #colorLiteral(red: 0.1933380365, green: 0.7166928649, blue: 0.03345341235, alpha: 1)
            view.addSubview(buttonSection1)
            buttonSection1.frame = view.frame
            buttonSection1.addTarget(self, action: #selector(self.hederTapped1), for: .touchUpInside)
        case 2:
            label.text = NSLocalizedString("Restaurant", comment: "")
            image.image = UIImage(named: "blue")
            label.textColor = #colorLiteral(red: 0.04475270212, green: 0.4369654357, blue: 0.7193379998, alpha: 1)
            view.addSubview(buttonSection2)
            buttonSection2.frame = view.frame
            buttonSection2.addTarget(self, action: #selector(self.hederTapped2), for: .touchUpInside)
        default:
            return view
        }
        return view
    }

    // MARK: - Cell settings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PanelCellController
        switch indexPath.section {
        case 0: cell.setValue(currentPanel: Cloud.section0[indexPath.row])
        case 1: cell.setValue(currentPanel: Cloud.section1[indexPath.row])
        case 2: cell.setValue(currentPanel: Cloud.section2[indexPath.row])
        default:
            return cell
        }
        return cell
    }
    
    // MARK: - Did select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: currentPanel = Cloud.section0[indexPath.row]
        case 1: currentPanel = Cloud.section1[indexPath.row]
        case 2: currentPanel = Cloud.section2[indexPath.row]
        default:
            return
        }
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
    
    // MARK: - Collapsed func
    @objc func hederTapped0() {
        collapsedSection0 = collapsedSection0 ? false : true
        collapsedSection1 = false
        collapsedSection2 = false
        tableView.reloadSections(IndexSet(0...2), with: .automatic)
    }
    @objc func hederTapped1() {
        collapsedSection1 = collapsedSection1 ? false : true
        collapsedSection0 = false
        collapsedSection2 = false
        tableView.reloadSections(IndexSet(0...2), with: .automatic)
    }
    @objc func hederTapped2() {
        collapsedSection2 = collapsedSection2 ? false : true
        collapsedSection0 = false
        collapsedSection1 = false
        tableView.reloadSections(IndexSet(0...2), with: .automatic)
    }

    
}
