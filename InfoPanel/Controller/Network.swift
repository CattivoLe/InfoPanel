//
//  Network.swift
//  DO Panel
//
//  Created by Alexander Omelchuk on 28.03.2019.
//  Copyright © 2019 Alexander Omelchuk. All rights reserved.
//

import Foundation
import NMSSH

class Network {
    
    //MARK: - Connect to server
    func connectToServer(session: NMSSHSession, pass: String) -> Bool {
        var result = false
        session.connect()
        if session.isConnected == true {
            print("connected")
            session.authenticate(byPassword: pass)
            if session.isAuthorized == true {
                print("authorized")
                result = true
            }
        }
        return result
    }
    
    //MARK: - Отправка и запуск картинки
    func sendDataToSeerver(session: NMSSHSession, data: Data, path: String, indicator: UIActivityIndicatorView) {
        var success = false
        let existFile = session.sftp.fileExists(atPath: path) // Проверить есть ли файл
        if existFile {
            success = session.sftp.writeContents(data, toFileAtPath: path) // Перезаписать картинку
        } else {
            success = session.sftp.appendContents(data, toFileAtPath: path) // Отправить картинку
        }
        if success {
            session.channel.execute("sudo pkill fbi", error: nil)
            session.channel.execute("sudo fbi -T 1 -a --noverbose \(path)", error: nil) // Запустить картинку
            DispatchQueue.main.async {
                indicator.stopAnimating()
            }
        } else {
            print("failure")
            DispatchQueue.main.async {
                indicator.stopAnimating()
            }
        }
    }
    
    
}
