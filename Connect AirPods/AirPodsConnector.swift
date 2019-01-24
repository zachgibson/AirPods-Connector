//
//  AirPodsConnector.swift
//  Connect AirPods
//
//  Created by Zach Gibson on 1/18/19.
//  Copyright © 2019 Zach Gibson. All rights reserved.
//

import Foundation
import IOBluetooth

class AirPodsConnector {
    var airPodsBluetoothDevice = IOBluetoothDevice()
    var airPodsBluetoothDeviceAddress = ""
    var blueToothDevices: [IOBluetoothDevice] = []
    let defaults = UserDefaults.standard
    let airPodsAddressStringKeyName = "addressString"
    
    func getRecentlyUsedBlueToothDevices() {
        guard let recentDevices = IOBluetoothDevice.recentDevices(10) else {
            print("No devices")
            return
        }
        
        for item in recentDevices {
            if let device = item as? IOBluetoothDevice {
                blueToothDevices.append(device)
            }
        }
    }
    
    func isConnected() -> Bool {
        if airPodsBluetoothDevice.isConnected() {
            return true
        }
        
        if let blueToothDeviceAddressString = defaults.object(forKey: airPodsAddressStringKeyName) as? String {
            let airPods = IOBluetoothDevice(addressString: blueToothDeviceAddressString)
            return (airPods?.isConnected())!
        }
        
        return false
    }
    
    func setAirPodsBluetoothDeviceAddress(completionHandler: () -> Void) {
        if let blueToothDeviceAddressString = defaults.object(forKey: airPodsAddressStringKeyName) as? String {
            airPodsBluetoothDeviceAddress = blueToothDeviceAddressString
            completionHandler()
        }
    }
    
    func connectNewAirPods(addressString: String) {
        airPodsBluetoothDevice = IOBluetoothDevice(addressString: addressString)
        airPodsBluetoothDevice.openConnection()
        defaults.setValue(addressString, forKey: airPodsAddressStringKeyName)
    }
    
    func connectExistingAirPods(completionHandler: () -> Void) {
        if airPodsBluetoothDeviceAddress != "" {
            let airPods = IOBluetoothDevice(addressString: airPodsBluetoothDeviceAddress)
            airPods?.openConnection()
            completionHandler()
            return
        }
        
        if let blueToothDeviceAddressString = defaults.object(forKey: airPodsAddressStringKeyName) {
            let airPods = IOBluetoothDevice(addressString: blueToothDeviceAddressString as? String)
            airPods?.openConnection()
            completionHandler()
        }
    }
    
    func disconnectAirPods(completionHandler: () -> Void) {
        if airPodsBluetoothDeviceAddress != "" {
            let airPods = IOBluetoothDevice(addressString: airPodsBluetoothDeviceAddress)
            airPods?.closeConnection()
            completionHandler()
            return
        }
        
        if let blueToothDeviceAddressString = defaults.object(forKey: airPodsAddressStringKeyName) {
            let airPods = IOBluetoothDevice(addressString: blueToothDeviceAddressString as? String)
            airPods?.closeConnection()
            completionHandler()
        }
    }
}
