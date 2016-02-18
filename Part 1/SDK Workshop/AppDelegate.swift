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
        
        // Initiate Beacon Manager
        beaconManager = KTKBeaconManager(delegate: self)
        beaconManager.requestLocationAlwaysAuthorization()
        
        // Region
        let proximityUUID = NSUUID(UUIDString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
        let region = KTKBeaconRegion(proximityUUID: proximityUUID!, identifier: "region-identifier")
        
        //let region = KTKBeaconRegion(proximityUUID: proximityUUID!, major: 101, identifier: "region-identifier-M")
        //let region = KTKBeaconRegion(proximityUUID: proximityUUID!, major: 101, minor: 201, identifier: "region-identifier-M-m")
        
        // let secureProximityUUID = NSUUID(UUIDString: "<#Secure Proximity#>")
        // let secureRegion = KTKSecureBeaconRegion(secureProximityUUID: secureProximityUUID!, identifier: "region-identifier")
        
        // Region Properties
        region.notifyEntryStateOnDisplay = true
        
        //beaconManager.stopMonitoringForAllRegions()
        
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

        if let closestBeacon = beacons.sort({ $0.0.accuracy < $0.1.accuracy }).first where closestBeacon.accuracy > 0 {
            print("Closest Beacon is M: \(closestBeacon.major), m: \(closestBeacon.minor) ~ \(closestBeacon.accuracy) meters away.")
        }
    }
}

