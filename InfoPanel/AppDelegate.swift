//
//  AppDelegate.swift
//  InfoPanel
//
//  Created by Alexander Omelchuk on 30/03/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 0.5) // LaunchScreen Delay
        return true
    }


}

