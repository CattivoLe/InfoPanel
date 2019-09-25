//
//  TaptickFeedback.swift
//  InfoPanelExtension
//
//  Created by Александр Омельчук on 25.09.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class TaptickFeedback {
    
    enum FeedbackType {
        case heavy
        case medium
        case light
        case succes
    }
    
    class func feedback(style: FeedbackType) {
        switch style {
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .succes:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    
}
