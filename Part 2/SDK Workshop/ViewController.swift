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

    @IBOutlet weak var imageView: UIImageView!
    
    var beaconManager: KTKBeaconManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initiate Beacon Manager
        beaconManager = KTKBeaconManager(delegate: self)
        beaconManager.requestLocationAlwaysAuthorization()
        
        // Region
        //let proximityUUID = NSUUID(UUIDString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
        //let region = KTKBeaconRegion(proximityUUID: proximityUUID!, identifier: "region-identifier")
        
        //let region = KTKBeaconRegion(proximityUUID: proximityUUID!, major: 101, identifier: "region-identifier-M")
        //let region = KTKBeaconRegion(proximityUUID: proximityUUID!, major: 101, minor: 201, identifier: "region-identifier-M-m")
        
        let secureProximityUUID = NSUUID(UUIDString: "6a063de4-3313-4608-a2cf-1a2585585c19")
        let secureRegion = KTKSecureBeaconRegion(secureProximityUUID: secureProximityUUID!, identifier: "region-identifier")
        
        // Region Properties
        secureRegion.notifyEntryStateOnDisplay = true
        secureRegion.assistedMonitoringEvents = true
        
        //beaconManager.stopMonitoringForAllRegions()
        
        // Start Ranging
        beaconManager.startMonitoringForRegion(secureRegion)
    }
    
    func getDataForBeacon(beacon: CLBeacon) {
        // Parameters
        let parameters = [
            "proximity": beacon.proximityUUID.UUIDString,
            "major": beacon.major,
            "minor": beacon.minor
        ]
        
        // Log
        print("Getting Data for Beacon with parameters: \(parameters)")
        
        // Get Device
        KTKCloudClient.sharedInstance().getObjects(KTKDevice.self, parameters: parameters) { [weak self] response, error in
            if let device = response?.objects?.first as? KTKDevice {
                self?.getActionForDevice(proximity: beacon.proximity, device: device)
            }
        }
    }
    
    func getActionForDevice(proximity proximity:CLProximity, device: KTKDevice) {
        
        // Log
        print("Getting Action for Beacon with unique ID: \(device.uniqueID)")
        
        KTKCloudClient.sharedInstance().getObjects(KTKAction.self, parameters: ["uniqueId": device.uniqueID]) { [weak self] response, error in
            
            if  let action = response?.objects?.first as? KTKAction where action.proximity == proximity,
                let content = action.content where content.type == .Image
            {
                // Download Image
                content.downloadContentDataWithCompletion { data, error in
                    if let data = data, let image = UIImage(data: data) {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
}

extension ViewController: KTKBeaconManagerDelegate {
    
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
        
        // Request State
        manager.requestStateForRegion(region)
    }
    
    func beaconManager(manager: KTKBeaconManager, didEnterRegion region: KTKBeaconRegion) {
        print("Did enter region: \(region)")
        
        manager.startRangingBeaconsInRegion(region)
    }
    
    func beaconManager(manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        print("Did exit region \(region)")
        
        self.imageView.image = nil
    }
    
    func beaconManager(manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], inRegion region: KTKBeaconRegion) {
        print("Did ranged \"\(beacons.count)\" beacons inside region: \(region)")
        
        if let closestBeacon = beacons.sort({ $0.0.accuracy < $0.1.accuracy }).first where closestBeacon.accuracy > 0 {
            // Log
            print("Closest Beacon: \(closestBeacon)")
            
            manager.stopRangingBeaconsInRegion(region)
            
            // Get Data
            getDataForBeacon(closestBeacon)
        }
    }
}

