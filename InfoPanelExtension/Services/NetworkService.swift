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
    private let killOMX = "sudo pkill omxplayer"
    private let killFbi = "sudo pkill fbi"
    private let startFbi = "sudo fbi -T 1 -a --noverbose "
    
    //MARK: - Send image to phone
    
    func sendImage(host:String, data: Data?) {
        
        let session = NMSSHSession(host: host, andUsername: "pi")
        session.connect()
        if session.isConnected {
            session.authenticate(byPassword: "pi")
            session.sftp.connect()
        }
        guard let imageData = data else { return }
        var success = false
        let existFile = session.sftp.fileExists(atPath: imagePath)
        
        if existFile {
            success = session.sftp.writeContents(imageData, toFileAtPath: imagePath)
        } else {
            success = session.sftp.appendContents(imageData, toFileAtPath: imagePath)
        }
        
        if success {
            print("File load ok")
            openImage(session: session)
        }
        session.sftp.disconnect()
        session.disconnect()
    }
    
    //MARK: - Open image Func
    private func openImage(session: NMSSHSession) {
        session.channel.execute(killFbi, error: nil)
        session.channel.execute(killOMX, error: nil)
        session.channel.execute("\(startFbi)\(imagePath)", error: nil)
    }
    
    
}
