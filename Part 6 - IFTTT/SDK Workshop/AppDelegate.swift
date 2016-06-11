//
//  AppDelegate.swift
//  SDK Workshop
//
//  Created by Marek Serafin on 15/02/16.
//  Copyright © 2016 Marek Serafin. All rights reserved.
//

import UIKit
import KontaktSDK
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var beaconManager: KTKBeaconManager!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initiate Beacon Manager
        beaconManager = KTKBeaconManager(delegate: self)
        beaconManager.requestLocationAlwaysAuthorization()
        
        // Region
        let proximityUUID = NSUUID(UUIDString: "4b6f6e74-616b-742e-696f-4d6f74696f6e")
        let region = KTKBeaconRegion(proximityUUID: proximityUUID!, major: 1234, minor: 5678, identifier: "motion-region")
        
        // Region Properties
        region.notifyEntryStateOnDisplay = true
        
        beaconManager.stopMonitoringForAllRegions()
        
        // Start Ranging
        beaconManager.startMonitoringForRegion(region)
        beaconManager.requestStateForRegion(region)
        
        return true
    }
}

extension AppDelegate: KTKBeaconManagerDelegate {
    
    func beaconManager(manager: KTKBeaconManager, didDetermineState state: CLRegionState, forRegion region: KTKBeaconRegion) {
        print("Did determine state \"\(state.rawValue)\" for region: \(region)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didChangeLocationAuthorizationStatus status: CLAuthorizationStatus) {
        print("Did change location authorization status to: \(status.rawValue)")
    }
    
    func beaconManager(manager: KTKBeaconManager, monitoringDidFailForRegion region: KTKBeaconRegion?, withError error: NSError?) {
        print("Monitoring did fail for region: \(region)")
        print("Error: \(error)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didStartMonitoringForRegion region: KTKBeaconRegion) {
        print("Did start monitoring for region: \(region)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didEnterRegion region: KTKBeaconRegion) {
        print("Did enter region: \(region)")
        
        let parameters = [
            "value1": region.proximityUUID.UUIDString,
            "value2": String(region.major!),
            "value3": String(region.minor!),
        ]
        
        // Lets call maker
        Alamofire.request(.POST, "https://maker.ifttt.com/trigger/<#Event Name#>/with/key/<#Your Maker Key#>", parameters: parameters, encoding: .JSON)
    }
    
    func beaconManager(manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        print("Did exit region \(region)")
    }
}

