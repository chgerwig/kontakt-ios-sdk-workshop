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
    
    var devicesManager: KTKDevicesManager!
    var connection: KTKDeviceConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initiate Devices Manager
        devicesManager = KTKDevicesManager(delegate: self)
        
        // Start Discovery
        devicesManager.startDevicesDiscoveryWithInterval(2.0)
    }
}

extension ViewController: KTKDevicesManagerDelegate {
    
    func devicesManagerDidFailToStartDiscovery(manager: KTKDevicesManager, withError error: NSError?) {
        
    }
    
    func devicesManager(manager: KTKDevicesManager, didDiscoverDevices devices: [KTKNearbyDevice]?) {
        
        print("Devices Manager found \(devices?.count) kontakt devices")
        
        if let device = devices?.filter({ $0.uniqueID == "<#unique id#>" }).first {
            manager.stopDevicesDiscovery()
            
            let configuration = KTKDeviceConfiguration(uniqueID: "<#unique id#>")
            configuration.major = 1000
            configuration.minor = 2000
            
            connection = KTKDeviceConnection(nearbyDevice: device)
            if let connection = connection {
                // Write Configuration
                connection.writeConfiguration(configuration) { synchronized, configuration, error in
                    if let _ = error {
                        print("Error while configuring")
                    }
                    else {
                        print("Configuration applied")
                    }
                }
                
                // Update Firmware
                KTKFirmware.getFirmwaresForUniqueIDs(["<#unique id#>"]) { firmware, error in
                    if let firmware = firmware?.first {
                        connection.updateWithFirmware(firmware, progress: { print("Firmware update progress: \($0)") }) { success, error in
                            if let _ = error {
                                print("Error while configuring")
                            }
                            else {
                                print("Firmware update completed")
                            }
                        }
                    }
                }
            }
        }
    }
}

