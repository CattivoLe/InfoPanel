//
//  Network.swift
//  DO Panel
//
//  Created by Alexander Omelchuk on 28.03.2019.
//  Copyright © 2019 Alexander Omelchuk. All rights reserved.
//

import Foundation
import NMSSH

var currentServerAddress: String?

class Network {
    
    private let killFbi = "sudo pkill fbi"
    private let killOmx = "sudo pkill omxplayer"
    private let sendOpen = "sudo fbi -T 1 -a --noverbose "
    private let pathImg = "/home/pi/Pictures/FromIPhone.jpg"
    private let snapshot = "/home/pi/snapshot.png"
    private let getSnapshot = "raspi2png --width 640 --height 360 --compression 1"
    
    // MARK: - Connect to server
    func connectToServer(address: String?) -> NMSSHSession? {
        guard let address = address else { return nil }
        let session = NMSSHSession(host: address, andUsername: "pi")
        session.connect()
        
        if session.isConnected == true {
            session.authenticate(byPassword: "pi")
            return session.isAuthorized == true ? session : nil
        } else {
            return nil
        }
    }
    
    // MARK: - Seng picture to panel
    func sendDataToSeerver(session: NMSSHSession, data: Data, indicator: UIActivityIndicatorView) {
        var success = false
        session.sftp.connect()
        
        let existFile = session.sftp.fileExists(atPath: pathImg) // Проверить есть ли файл
        if existFile {
            success = session.sftp.writeContents(data, toFileAtPath: pathImg) // Перезаписать картинку
        } else {
            success = session.sftp.appendContents(data, toFileAtPath: pathImg) // Создать картинку
        }
        
        if success {
            session.channel.execute(killFbi, error: nil)
            session.channel.execute(killOmx, error: nil)
            session.channel.execute("\(sendOpen)\(pathImg)", error: nil) // Запустить картинку
            DispatchQueue.main.async {
                indicator.stopAnimating()
            }
        } else {
            DispatchQueue.main.async {
                indicator.stopAnimating()
            }
        }
        session.sftp.disconnect()
        session.disconnect()
    }
    
    // MARK: - Get snapshot
    func getSnapshot(session: NMSSHSession) -> Data? {
        session.sftp.connect()
        session.channel.execute(getSnapshot, error: nil)
        
        let data = session.sftp.contents(atPath: snapshot)
        session.sftp.disconnect()
        session.disconnect()
        
        return data
    }
    
    
}
