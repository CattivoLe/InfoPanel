//
//  ViewController.swift
//  DO Panel
//
//  Created by Alexander Omelchuk on 28.03.2019.
//  Copyright © 2019 Alexander Omelchuk. All rights reserved.
//

import UIKit
import NMSSH

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let network = Network()
    var dataToSend = Data()
    var address = "0.0.0.0"
    var panelName = "Panel"
    var notes = "Some Panel"
    let pathImg = "/home/pi/Pictures/FromIPhone.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = panelName
        descriptionLabel.text = notes
        chekConnect()
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        self.chooseImage()
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
        guard let data = image.pngData() else {return} // Подготовить картинку
        imageView.image = UIImage(data: data)
        imageView.contentMode = .scaleAspectFit
        dataToSend = data
        dismiss(animated: true)
    }
    
    //MARK: - Пробное подключение
    func chekConnect() {
        let session = NMSSHSession(host: address, andUsername: "pi")
        let result = network.connectToServer(session: session, pass: "pi")
        if result {
            imageView.image = UIImage(named: "online")
            session.disconnect()
        } else {
            imageView.image = UIImage(named: "offline")
        }
    }
    
    //MARK: - Загрузка картинки на панель
    @IBAction func loadDataPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        let loadData = DispatchQueue.init(label: "loadData")
        loadData.async {
            let session = NMSSHSession(host: self.address, andUsername: "pi")
            let result = self.network.connectToServer(session: session, pass: "pi")
            if result {
                session.sftp.connect()
                self.network.sendDataToSeerver(session: session, data: self.dataToSend, path: self.pathImg, indicator: self.activityIndicator)
            }
            session.sftp.disconnect()
            session.disconnect()
        }
    }
    
    //MARK: - Сброс картинки
    @IBAction func cancelImagePressed(_ sender: UIButton) {
        let session = NMSSHSession(host: address, andUsername: "pi")
        let result = network.connectToServer(session: session, pass: "pi")
        if result {
            session.channel.execute("sudo pkill fbi", error: nil)
        }
        session.disconnect()
        imageView.image = UIImage(named: "online")
    }
    
    //MARK: - Сброс приставки
    @IBAction func rebootButtonePressed(_ sender: UIButton) {
        rebootAllert()
    }
    
    func rebootAllert() {
        let allertController = UIAlertController(title: "You sure?", message: "The panel will be reloaded", preferredStyle: .alert)
        let rebootButton = UIAlertAction(title: "Reboot", style: .destructive) { (action) in
            let session = NMSSHSession(host: self.address, andUsername: "pi")
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

