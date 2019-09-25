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
    
    func loadAttachmentObject(panel: Panel, vc: UIViewController, network: NetworkService) {
        guard let extensionContext = vc.extensionContext else { return }
        let item = extensionContext.inputItems.first as? NSExtensionItem
        let attachment = item?.attachments?.first
        var contentType = kUTTypeURL as String
        var imageData: Data?
        
        if !(attachment?.hasItemConformingToTypeIdentifier(contentType))! {
            contentType = kUTTypeImage as String
        }
        attachment?.loadItem(forTypeIdentifier: contentType, completionHandler: { (data, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            if let data = data as? Data {
                imageData = data
            }
            if let url = data as? URL {
                imageData = try! Data(contentsOf: url)
            }
            if let img = data as? UIImage {
                imageData = img.pngData()
            }
            guard let image = imageData else { return }
            guard let address = panel.address else { return }
            
            var finalImage: Data?
            if panel.orient == .vertical {
                finalImage = UIImage(data: image)?.imageRotated(on: 90).pngData()
            } else {
                finalImage = imageData
            }
            network.sendImage(host: address, data: finalImage)
            vc.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        })
    }
    
    
}

    //MARK: - Rotate Image

extension UIImage {
    func imageRotated(on degrees: CGFloat) -> UIImage {
        let degrees = round(degrees / 90) * 90
        let sameOrientationType = Int(degrees) % 180 == 0
        let radians = CGFloat.pi * degrees / CGFloat(180)
        let newSize = sameOrientationType ? size : CGSize(width: size.height, height: size.width)
        UIGraphicsBeginImageContext(newSize)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return self
        }
        ctx.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        ctx.rotate(by: radians)
        ctx.scaleBy(x: 1, y: -1)
        let origin = CGPoint(x: -(size.width / 2), y: -(size.height / 2))
        let rect = CGRect(origin: origin, size: size)
        ctx.draw(cgImage, in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image ?? self
    }
}

