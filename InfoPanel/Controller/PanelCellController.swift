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
        imageViewCell.image = UIImage(named: (currentPanel.object(forKey: "group") as? String)!)
        nameLabelCell.text = currentPanel.object(forKey: "name") as? String
    }
    
}
