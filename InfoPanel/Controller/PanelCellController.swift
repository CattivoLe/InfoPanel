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
        
        switch currentPanel.object(forKey: "group") as? String {
        case "orange": nameLabelCell.textColor = #colorLiteral(red: 0.9032962322, green: 0.3431209326, blue: 0.02910011634, alpha: 1)
        case "green": nameLabelCell.textColor = #colorLiteral(red: 0.1933380365, green: 0.7166928649, blue: 0.03345341235, alpha: 1)
        case "blue": nameLabelCell.textColor = #colorLiteral(red: 0.04475270212, green: 0.4369654357, blue: 0.7193379998, alpha: 1)
        default: nameLabelCell.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        guard let image = currentPanel.object(forKey: "image") as? CKAsset else {return}
        if currentPanel.object(forKey: "orient") as? String == "v" {
            imageViewCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / (2 / 3)))
        } else {
            imageViewCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / (0.5 / 3)))
        }
        let data = try? Data(contentsOf: image.fileURL)
        if let data = data {
            self.imageViewCell.image = UIImage(data: data)
        }
    }
    
    
}
