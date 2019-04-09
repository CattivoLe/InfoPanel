//
//  VideoFilesController.swift
//  InfoPanel
//
//  Created by Alexander Omelchuk on 08.04.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import NMSSH

class VideoFilesController: UITableViewController {
    
    let network = Network()
    var videoFilesArray: [NMSFTPFile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getFiles()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoFilesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = videoFilesArray[indexPath.row].filename
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentFile = videoFilesArray[indexPath.row].filename
        playVideo(name: currentFile)
        tableView.deselectRow(at: indexPath, animated: false)
        self.dismiss(animated: true)
    }
    
    // MARK: - Запустить воспроизведение видео
    func playVideo(name: String) {
        DispatchQueue.global().async {
            guard let session = self.network.connectToServer(address: currentServerAddress!) else {return}
            session.channel.execute("sudo pkill omxplayer", error: nil)
            session.channel.execute("nohup omxplayer --no-osd --loop /home/pi/Videos/\(name) > /dev/null &", error: nil)
            session.disconnect()
        }
    }
    
    // MARK: - Получить список файлов
    @objc func getFiles() {
        DispatchQueue.global().async {
            guard let session = self.network.connectToServer(address: currentServerAddress!) else {return}
            session.sftp.connect()
            guard let array = session.sftp.contentsOfDirectory(atPath: "/home/pi/Videos/") else {return}
            self.videoFilesArray = array
            session.disconnect()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    

}
