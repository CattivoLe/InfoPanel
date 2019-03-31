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
    
    var dataToSend = Data()
    var address = "0.0.0.0"
    var panelName = "Panel"
    var notes = "Some Panel"
    let pathImg = "/home/pi/Pictures/FromIPhone.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = panelName
        descriptionLabel.text = notes
        chekConnect()
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        self.chooseImage()
        print("test")
    }
    
    // MARK: - ImagePicker Controller
    func chooseImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { // Проверка доступности библиотеки
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
    
    func chekConnect() {
        let session = NMSSHSession(host: address, andUsername: "pi")
        let result = Network.connectToServer(session: session, pass: "pi")
        if result {
            imageView.image = UIImage(named: "online")
            session.disconnect()
        } else {
            imageView.image = UIImage(named: "offline")
        }
    }
    
    @IBAction func loadDataPressed(_ sender: UIButton) {
        let session = NMSSHSession(host: address, andUsername: "pi")
        let result = Network.connectToServer(session: session, pass: "pi")
        if result {
            session.sftp.connect()
            Network.sendDataToSeerver(session: session, data: dataToSend, path: pathImg)
        }
        session.sftp.disconnect()
        session.disconnect()
    }
    
    @IBAction func cancelImagePressed(_ sender: UIButton) {
        let session = NMSSHSession(host: address, andUsername: "pi")
        let result = Network.connectToServer(session: session, pass: "pi")
        if result {
            session.channel.execute("sudo pkill fbi", error: nil)
        }
        session.disconnect()
    }
    
    
}

