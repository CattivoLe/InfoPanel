//
//  PanelCellController.swift
//  InfoPanel
//
//  Created by Alexander Omelchuk on 05.04.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import CloudKit

class PanelCellController: UITableViewCell {
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var nameLabelCell: UILabel!

    func setValue(currentPanel: CKRecord) {
        imageViewCell.clipsToBounds = true
        imageViewCell.layer.cornerRadius = 5
        nameLabelCell.text = currentPanel.object(forKey: "name") as? String
        guard let image = currentPanel.object(forKey: "image") as? CKAsset else {return}
        let data = try? Data(contentsOf: image.fileURL)
        if let data = data {
            self.imageViewCell.image = UIImage(data: data)
        }
    }
    
    
}
