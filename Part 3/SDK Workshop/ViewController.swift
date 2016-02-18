//
//  ViewController.swift
//  SDK Workshop
//
//  Created by Marek Serafin on 15/02/16.
//  Copyright © 2016 Marek Serafin. All rights reserved.
//

import UIKit
import KontaktSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var eddystoneManger: KTKEddystoneManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initiate Beacon Manager
        eddystoneManger = KTKEddystoneManager(delegate: self)
        
        // Region
        //let regionNamespace = KTKEddystoneRegion(namespaceID: "<#Namespace#>")
        //let regionNamespace = KTKSecureEddystoneRegion(secureNamespaceID: "<#Secure Namespace#>")
        // let regionDomain = KTKEddystoneRegion(URLDomain: "kontakt.io")
        
        eddystoneManger.startEddystoneDiscoveryInRegion(nil)
    }
}

extension ViewController: KTKEddystoneManagerDelegate {
    
    func eddystoneManagerDidFailToStartDiscovery(manager: KTKEddystoneManager, withError error: NSError?) {
        print("Did fail to start discovery: \(error)")
    }
    
    func eddystoneManager(manager: KTKEddystoneManager, didDiscoverEddystones eddystones: Set<KTKEddystone>, inRegion region: KTKEddystoneRegion?) {
        
        print("Did discover \(eddystones.count) eddystones")
        
        for eddystone in eddystones {
            if let url = eddystone.eddystoneURL?.url {
                print("Eddystone URL: \(url)")
            }
        }
        
        // Load First URL
//        if let url = eddystones.first?.eddystoneURL?.url {
//            manager.stopEddystoneDiscoveryInAllRegions()
//            
////            webView.loadRequest(NSURLRequest(URL: url))
//            
////            let notification = UILocalNotification()
////            notification.alertBody = "Eddystone: \(url.absoluteString)"
////            notification.fireDate = NSDate()
////            
////            UIApplication.sharedApplication().scheduleLocalNotification(notification)
//        }
    }
    
    func eddystoneManager(manager: KTKEddystoneManager, didUpdateEddystone eddystone: KTKEddystone, withFrame frameType: KTKEddystoneFrameType) {
        // print("Did update eddystone: \(eddystone)")
    }
}

