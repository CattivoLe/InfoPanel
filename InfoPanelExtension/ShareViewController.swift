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
    let spinner = UIActivityIndicatorView()
    let cellIdentifire = "Cell"
    
    //MARK: - View Load
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        cloudService.getPanels(finishFunc: finishLoadFunc)
    }
    override func viewDidLoad() {
        super .viewDidLoad()
        setupTableView()
        setupViewSpinner()
    }
    
    //MARK: - Setup View & Spinner
    
    private func setupViewSpinner() {
        self.view.layer.cornerRadius = 30
        self.view.layer.masksToBounds = true
        let center = CGPoint(x: 100, y: 100)
        let size = CGSize(width: 100, height: 100)
        spinner.frame = CGRect(origin: center, size: size)
        spinner.style = .large
        spinner.color = .white
        view.insertSubview(spinner, aboveSubview: tableView)
    }

    
    //MARK: - TableVIew Setup
    
    private func setupTableView() {
        let width = view.bounds.width
        let height = view.bounds.height
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        tableView.backgroundColor = .black
        tableView.alpha = 0.9
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func finishLoadFunc() {
        DispatchQueue.main.async {
            TaptickFeedback.feedback(style: .succes)
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Delegate DataSourse
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cloudService.panelsArrey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
        let panel = cloudService.panelsArrey[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        switch panel.group {
        case .blue:
            cell.textLabel?.textColor = #colorLiteral(red: 0.04475270212, green: 0.4369654357, blue: 0.7193379998, alpha: 1)
        case .green:
            cell.textLabel?.textColor = #colorLiteral(red: 0.1933380365, green: 0.7166928649, blue: 0.03345341235, alpha: 1)
        default:
            cell.textLabel?.textColor = #colorLiteral(red: 0.9032962322, green: 0.3431209326, blue: 0.02910011634, alpha: 1)
        }
        if panel.orient != .vertical {
            cell.imageView?.image = UIImage(named: "h.jpeg")
        } else {
            cell.imageView?.image = UIImage(named: "v.jpeg")
        }
        cell.textLabel?.text = panel.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TaptickFeedback.feedback(style: .medium)
        spinner.startAnimating()
        tableView.deselectRow(at: indexPath, animated: true)
        let currentPanel = cloudService.panelsArrey[indexPath.row]
        attachment.loadAttachmentObject(panel: currentPanel, vc: self, network: networkService)
    }
        
    
}
