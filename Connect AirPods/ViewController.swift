//
//  ViewController.swift
//  Connect AirPods
//
//  Created by Zach Gibson on 1/14/19.
//  Copyright © 2019 Zach Gibson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    let connector = AirPodsConnector()
    @IBOutlet weak var popUpButton: NSPopUpButton?
    let airPodsAddressStringKeyName = "addressString"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        connector.tryToConnectAirPods()
//        
//        let window = NSApplication.shared.mainWindow
//        
//        window?.orderOut(self)
//
//        if (UserDefaults.standard.object(forKey: airPodsAddressStringKeyName) == nil) {
//            window?.makeKeyAndOrderFront(self)
//            connector.getRecentlyUsedBlueToothDevices()
//            for device in connector.blueToothDevices {
//                if let deviceName = device.name {
//                    popUpButton?.addItem(withTitle: deviceName)
//                    
//                    if deviceName.contains("AirPods") {
//                        popUpButton?.selectItem(withTitle: deviceName)
//                    }
//                }
//            }
//        }
    }
    
//    @IBAction func onButtonClick(_ sender: NSButton) {
//        for device in connector.blueToothDevices {
//            if device.name == popUpButton?.selectedItem?.title {
//                connector.connectNewAirPods(device.addressString)
//            }
//        }
//    }


}
