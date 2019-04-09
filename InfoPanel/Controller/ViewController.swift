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
    
    var panel: CKRecord?
    let network = Network()
    var dataToSend = Data()
    var panelAvailable = false
    var dataAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToPanel()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "StartVideo"), object: nil, queue: nil) { (notification) in
            self.connectToPanel()
        }
        let rightBut = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(connectToPanel))
        self.navigationItem.setRightBarButton(rightBut, animated: false)
        if panel?.object(forKey: "orient") as? String == "v" {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }
        nameLabel.text = panel?.object(forKey: "name") as? String
        descriptionLabel.text = panel?.object(forKey: "notes") as? String
        currentServerAddress = panel?.object(forKey: "address") as? String
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var buttonLabels: [UIButton]!
    
    @IBAction func choseImageDownPressed(_ sender: UIButton) {
        TaptickFeedback.feedback(style: .medium)
        imageView.alpha = 0.5
    }
    @IBAction func choseImageUpPressed(_ sender: UIButton) {
        TaptickFeedback.feedback(style: .light)
        imageView.alpha = 1
        if panelAvailable {
            self.chooseImage()
        }
    }
    @IBAction func playVideoButtonPressed(_ sender: UIButton) {
        if panelAvailable {
            showVideoFiles()
        }
    }
    @IBAction func resetButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if panelAvailable {
            allert(message: NSLocalizedString("Panel will be reloaded", comment: ""), okTitle: NSLocalizedString("Reboot", comment: "")) {
                self.rebootPanel()
            }
        }
    }
    @IBAction func cancelImagePressed(_ sender: UIButton) {
        if panelAvailable {
            allert(message: NSLocalizedString("Current image will be reset", comment: ""), okTitle: NSLocalizedString("Reset", comment: "")) {
                self.cleanScreen()
            }
        }
    }
    
    // MARK: - Загрузка картинки на панель
    @IBAction func loadDataPressed(_ sender: UIButton) {
        if dataAvailable {
            activityIndicator.startAnimating()
            DispatchQueue.global(qos: .utility).async {
                guard let session = self.network.connectToServer(address: self.panel?.object(forKey: "address") as! String) else {return}
                self.network.sendDataToSeerver(session: session, data: self.dataToSend, indicator: self.activityIndicator)
            }
        }
    }
    
    // MARK: - Connect func
    @objc func connectToPanel() {
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            guard let session = self.network.connectToServer(address: self.panel?.object(forKey: "address") as! String) else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.panelAvailable = false
                }
                return
            }
            guard let data = self.network.getSnapshot(session: session) else {return}
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
                self.panelAvailable = true
                self.buttonLabels[0].backgroundColor = #colorLiteral(red: 0.4025556445, green: 0.04715014249, blue: 0.6319543123, alpha: 1)
                self.buttonLabels[1].backgroundColor = #colorLiteral(red: 0.3206933737, green: 0.03235480934, blue: 0.4772351384, alpha: 1)
                self.buttonLabels[2].backgroundColor = #colorLiteral(red: 0.2433076203, green: 0.01837205701, blue: 0.3306440711, alpha: 1)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Сброс на рабочий стол
    func cleanScreen() {
        self.imageView.image = UIImage(named: "online")
        DispatchQueue.global(qos: .utility).async {
            guard let session = self.network.connectToServer(address: self.panel?.object(forKey: "address") as! String) else {return}
            session.channel.execute("sudo pkill fbi", error: nil)
            session.channel.execute("sudo pkill gpicview", error: nil) // Закрыть стандартую программу отображения картинок
            session.channel.execute("sudo pkill pcmanfm", error: nil) // Закрыть файловый менеджер
            session.channel.execute("sudo pkill omxplayer", error: nil)
        }
    }
    
    // MARK: - Перезагрузить панель
    func rebootPanel() {
        guard let session = self.network.connectToServer(address: self.panel?.object(forKey: "address") as! String) else {return}
        session.channel.execute("sudo reboot", error: nil)
        session.disconnect()
        self.imageView.image = UIImage(named: "offline")
        self.panelAvailable = false
        self.dataAvailable = false
        for button in self.buttonLabels {
            button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    // MARK: - Аллерт подтверждения действия
    func allert(message: String, okTitle: String, nameFunc: @escaping ()->()) {
        let allertController = UIAlertController(title: NSLocalizedString("You sure?", comment: ""), message: message, preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        let okButton = UIAlertAction(title: okTitle, style: .destructive) { (action) in
           nameFunc()
        }
        allertController.addAction(cancelButton)
        allertController.addAction(okButton)
        if panelAvailable {
            TaptickFeedback.feedback(style: .succes)
            self.present(allertController, animated: true)
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
    
    // MARK: - PopOver Controller
    func showVideoFiles() {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "VideoFiles") else {return}
        viewController.modalPresentationStyle = .popover
        let popOverVC = viewController.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.buttonLabels[1]
        popOverVC?.sourceRect = CGRect(x: self.buttonLabels[1].bounds.midX, y: self.buttonLabels[1].bounds.minY, width: 0, height: 0)
        viewController.preferredContentSize = CGSize(width: 250, height: 180)
        if currentServerAddress != nil {
            self.present(viewController, animated: true)
        }
    }
    
    
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

