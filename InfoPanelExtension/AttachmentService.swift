//
//  AttachmentService.swift
//  InfoPanelExtension
//
//  Created by Александр Омельчук on 24.09.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import MobileCoreServices

class AttachmentService {
    
    //MARK: - Load Attachment object from phone to server
    
    func loadAttachmentObject(host: String, vc: UIViewController, network: NetworkService) {
        guard let extensionContext = vc.extensionContext else { return }
        let item = extensionContext.inputItems.first as? NSExtensionItem
        let attachment = item?.attachments?.first
        let contentType = kUTTypeImage as String
        var imageData: Data?
        
        guard (attachment?.hasItemConformingToTypeIdentifier(contentType))! else { return }
        attachment?.loadItem(forTypeIdentifier: contentType, completionHandler: { (data, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            if let url = data as? URL {
                imageData = try! Data(contentsOf: url)
            }
            if let img = data as? UIImage {
                imageData = img.pngData()
            }
            network.sendImage(host: host, data: imageData)
            vc.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        })
    }
    
    
}
