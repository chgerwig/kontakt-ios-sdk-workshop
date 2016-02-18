//
//  AppDelegate.swift
//  SDK Workshop
//
//  Created by Marek Serafin on 15/02/16.
//  Copyright © 2016 Marek Serafin. All rights reserved.
//

import UIKit
import KontaktSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Set your API Key
        Kontakt.setAPIKey("<#Api Key#>")
        
        return true
    }
}

