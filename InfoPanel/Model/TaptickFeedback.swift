//
//  TaptickFeedback.swift
//  InfoPanel
//
//  Created by Alexander Omelchuk on 03.04.2019.
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
