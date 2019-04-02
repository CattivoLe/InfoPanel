//
//  ViewController.swift
//  DO Panel
//
//  Created by Alexander Omelchuk on 28.03.2019.
//  Copyright © 2019 Alexander Omelchuk. All rights reserved.
//

import UIKit
import NMSSH
import CloudKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let network = Network()
    var dataToSend = Data()
    var panel: CKRecord?
    let pathImg = "/home/pi/Pictures/FromIPhone.jpg"
    var panelAvailable = false
    var dataAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if panel?.object(forKey: "orient") as? String == "v" {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }
        nameLabel.text = panel?.object(forKey: "name") as? String
        descriptionLabel.text = panel?.object(forKey: "notes") as? String
        chekConnect()
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var showButtonLabel: [UIButton]!
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if panelAvailable {
            self.chooseImage()
        }
    }
    
    // MARK: - ImagePicker Controller
    func chooseImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        guard let data = image.pngData() else {return}
        imageView.image = UIImage(data: data)
        imageView.contentMode = .scaleAspectFit
        dataToSend = data
        dataAvailable = true
        dismiss(animated: true)
    }
    
    //MARK: - Пробное подключение
    func chekConnect() {
        let task = DispatchQueue.init(label: "chekConnect")
        task.async {
            let session = NMSSHSession(host: self.panel?.object(forKey: "address") as? String ?? "0.0.0.0", andUsername: "pi")
            let result = self.network.connectToServer(session: session, pass: "pi")
            if result {
                session.sftp.connect()
                session.channel.execute("raspi2png --width 640 --height 360 --compression 1", error: nil)
                let data = session.sftp.contents(atPath: "/home/pi/snapshot.png")
                
                self.panelAvailable = true
                session.disconnect()
                DispatchQueue.main.async {
                    if let image = data {
                        self.imageView.image = UIImage(data: image)
                    } else {
                        self.imageView.image = UIImage(named: "online")
                    }
                    for button in self.showButtonLabel {
                        button.backgroundColor = #colorLiteral(red: 0.51474154, green: 0.1420693099, blue: 0.5038574338, alpha: 1)
                    }
                }
            } else {
                self.panelAvailable = false
            }
        }
    }
    
    //MARK: - Загрузка картинки на панель
    @IBAction func loadDataPressed(_ sender: UIButton) {
        if dataAvailable {
            activityIndicator.startAnimating()
            let loadData = DispatchQueue.init(label: "loadData")
            loadData.async {
                let session = NMSSHSession(host: self.panel?.object(forKey: "address") as? String ?? "0.0.0.0", andUsername: "pi")
                let result = self.network.connectToServer(session: session, pass: "pi")
                if result {
                    session.sftp.connect()
                    self.network.sendDataToSeerver(session: session, data: self.dataToSend, path: self.pathImg, indicator: self.activityIndicator)
                }
                session.sftp.disconnect()
                session.disconnect()
            }
        }
    }
    
    //MARK: - Сброс картинки
    @IBAction func cancelImagePressed(_ sender: UIButton) {
        if panelAvailable {
            let session = NMSSHSession(host: self.panel?.object(forKey: "address") as? String ?? "0.0.0.0", andUsername: "pi")
            let result = network.connectToServer(session: session, pass: "pi")
            if result {
                session.channel.execute("sudo pkill fbi", error: nil)
            }
            session.disconnect()
            imageView.image = UIImage(named: "online")
        }
    }
    
    //MARK: - Перезагрузка приставки
    @IBAction func rebootButtonePressed(_ sender: UIButton) {
        if panelAvailable {
            rebootAllert()
        }
    }
    
    func rebootAllert() {
        let allertController = UIAlertController(title: "You sure?", message: "The panel will be reloaded", preferredStyle: .alert)
        let rebootButton = UIAlertAction(title: "Reboot", style: .destructive) { (action) in
            let session = NMSSHSession(host: self.panel?.object(forKey: "address") as? String ?? "0.0.0.0", andUsername: "pi")
            let result = self.network.connectToServer(session: session, pass: "pi")
            if result {
                session.channel.execute("sudo reboot", error: nil)
            }
            session.disconnect()
            self.imageView.image = UIImage(named: "offline")
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        allertController.addAction(rebootButton)
        allertController.addAction(cancelButton)
        self.present(allertController, animated: true)
    }
    
    
}

