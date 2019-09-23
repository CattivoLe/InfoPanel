//
//  NetworkService.swift
//  InfoPanelExtension
//
//  Created by Александр Омельчук on 23.09.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import Foundation
import NMSSH

class NetworkService {
    
    private let imagePath = "/home/pi/Pictures/FromIPhone.jpg"
    
    func sendImage(host:String, data: Data?) {
        
        let session = NMSSHSession(host: host, andUsername: "pi")
        session.connect()
        if session.isConnected {
            session.authenticate(byPassword: "pi")
            session.sftp.connect()
        }
        guard let imageData = data else { return }
        let existFile = session.sftp.fileExists(atPath: imagePath)
        if existFile {
            session.sftp.writeContents(imageData, toFileAtPath: imagePath)
        } else {
            session.sftp.appendContents(imageData, toFileAtPath: imagePath)
        }
        session.disconnect()
    }
    
    
}
