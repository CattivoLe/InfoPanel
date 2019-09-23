//
//  ShareViewController.swift
//  InfoPanelExtension
//
//  Created by Александр Омельчук on 23.09.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import CloudKit

class ShareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var cloudService = CloudService()
    
    //MARK: - View did Load
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setupTableView()
        cloudService.getPanels(finishFunc: finishLoadFunc)
    }
    
    //MARK: - TableVIew Delegate DataSourse
    
    private func setupTableView() {
        let width = view.bounds.width
        let height = view.bounds.height
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func finishLoadFunc() {
        tableView.reloadData()
        print(cloudService.panelsArrey)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("Panels - \(self.cloudService.panelsArrey)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cloudService.panelsArrey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = cloudService.panelsArrey[indexPath.row].object(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(cloudService.panelsArrey[indexPath.row].object(forKey: "address") as? String as Any)
    }
    
    
}
