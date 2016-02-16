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

    var beaconManager: KTKBeaconManager!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Set API Key
        Kontakt.setAPIKey("<#API_KEY#>")
        
        // Initiate Beacon Manager
        beaconManager = KTKBeaconManager(delegate: self)
        beaconManager.requestLocationAlwaysAuthorization()
        
        // Region
        let proximityUUID = NSUUID(UUIDString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
        let region = KTKBeaconRegion(proximityUUID: proximityUUID!, identifier: "region-identifier")
        
        // Region Properties
        region.notifyEntryStateOnDisplay = true
        
        // Start Ranging
        beaconManager.startRangingBeaconsInRegion(region)
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
    }
    
    func beaconManager(manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        print("Did exit region \(region)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], inRegion region: KTKBeaconRegion) {
        print("Did ranged \"\(beacons.count)\" beacons inside region: \(region)")
    }
}

