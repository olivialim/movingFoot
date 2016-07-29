//
//  AppDelegate.swift
//  BeanBlinkOnButtonPRess
//
//  Created by Olivia Lim on 7/15/16.
//  Copyright © 2016 Olivia Lim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        setUpWindows()
        
        return true
    }
}

extension AppDelegate {
    
    private func setUpWindows() {
        setUpMainWindow()
    }
    
    private func setUpMainWindow() {
        guard window == nil else {
            return
        }
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = ShoeController()
        window?.backgroundColor = .greenColor()
        window?.makeKeyAndVisible()
    }
    
}

