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
    var networkService = NetworkService()
    var attachment = AttachmentService()
    let cellIdentifire = "Cell"
    
    //MARK: - View Load
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        cloudService.getPanels(finishFunc: finishLoadFunc)
    }
    override func viewDidLoad() {
        super .viewDidLoad()
        setupView()
        setupTableView()
    }
    
    //MARK: - Setup View
    
    private func setupView() {
        self.view.layer.cornerRadius = 30
        self.view.layer.masksToBounds = true
    }

    
    //MARK: - TableVIew Setup
    
    private func setupTableView() {
        let width = view.bounds.width
        let height = view.bounds.height
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func finishLoadFunc() {
        tableView.reloadData()
        DispatchQueue.main.async {
        }
    }
    
    //MARK: - TableView Delegate DataSourse
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cloudService.panelsArrey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.1077648476, green: 0.1164580062, blue: 0.1289991438, alpha: 1)
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = cloudService.panelsArrey[indexPath.row].object(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentPanel = cloudService.panelsArrey[indexPath.row]
        let address = currentPanel.object(forKey: "address") as! String
        attachment.loadAttachmentObject(host: address, vc: self, network: networkService)
    }
        
    
}
