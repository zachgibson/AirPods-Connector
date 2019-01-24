//
//  AppDelegate.swift
//  Connect AirPods
//
//  Created by Zach Gibson on 1/11/19.
//  Copyright © 2019 Zach Gibson. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var window = NSWindow()
    let windowFrameWidth = 560
    let windowFrameHeight = 320
    let connector = AirPodsConnector()
    let popUpButton = NSPopUpButton(frame: NSRect())
    let popUpButtonLabel = NSTextField(labelWithString: "AirPods Name:")
    let boxSeparator = NSBox()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let button = statusItem.button {
            
            connector.setAirPodsBluetoothDeviceAddress {
                if connector.isConnected() {
                    button.image = NSImage(named: NSImage.Name("StatusBarButtonImageFilled"))
                } else {
                    button.image = NSImage(named: NSImage.Name("StatusBarButtonImageNotFilled"))
                }
            }
            
            button.action = #selector(gucci(_:))
        }
        constructMenu()
        constructWindow()
    }
    
    func constructWindow() {
        let frame = NSRect(x: 0, y: 0, width: windowFrameWidth, height: windowFrameHeight)
        window = NSWindow(contentRect: frame, styleMask: [.titled, .closable, .miniaturizable], backing: .buffered, defer: false)
        window.title = "General"
        window.center()
        addUIToWindow()
    }
    
    func lookForExistingAirPods(completion: (Bool) -> Void) {
        if UserDefaults.standard.object(forKey: "addressString") != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    @objc func onPopUpButtonSelection(_ sender: NSPopUpButton) {
        for device in connector.blueToothDevices {
            if device.name == sender.selectedItem?.title {
                connector.connectNewAirPods(addressString: device.addressString)
            }
        }
    }
    
    func openWindow() {
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(self)
    }
    
    func addUIToWindow() {
        popUpButton.action = #selector(onPopUpButtonSelection(_:))
        window.contentView?.addSubview(popUpButton)

        popUpButtonLabel.alignment = .right
        window.contentView?.addSubview(popUpButtonLabel)
        
        boxSeparator.boxType = .separator
        window.contentView?.addSubview(boxSeparator)
        boxSeparator.translatesAutoresizingMaskIntoConstraints = false
        boxSeparator.topAnchor.constraint(equalTo: popUpButton.bottomAnchor, constant: 20).isActive = true
        boxSeparator.leadingAnchor.constraint(equalTo: (window.contentView?.leadingAnchor)!, constant: 20).isActive = true
        boxSeparator.trailingAnchor.constraint(equalTo: (window.contentView?.trailingAnchor)!, constant: -20).isActive = true
        
        popUpButton.translatesAutoresizingMaskIntoConstraints = false
        popUpButton.topAnchor.constraint(equalTo: (window.contentView?.topAnchor)!, constant: 40).isActive = true
        popUpButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        popUpButton.centerXAnchor.constraint(equalTo: (window.contentView?.centerXAnchor)!).isActive = true
        
        popUpButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        popUpButtonLabel.centerYAnchor.constraint(equalTo: popUpButton.centerYAnchor).isActive = true
        popUpButtonLabel.leadingAnchor.constraint(equalTo: (window.contentView?.leadingAnchor)!, constant: 20).isActive = true
        popUpButtonLabel.trailingAnchor.constraint(equalTo: popUpButton.leadingAnchor, constant: -8).isActive = true
        
        lookForExistingAirPods { (doesExist) in
            if doesExist {
                connector.setAirPodsBluetoothDeviceAddress {
                    return
                }
            } else {
                openWindow()
                populatePopUpButtonItems()
            }
        }
    }
    
    func populatePopUpButtonItems() {
        connector.getRecentlyUsedBlueToothDevices()
        for device in connector.blueToothDevices {
            popUpButton.addItem(withTitle: device.name)
        }
    }
    
    @objc func gucci(_ sender: Any?) {
        print("gucci")
    }
    
    @objc func connect(_ sender: Any?) {
        connector.connectExistingAirPods {
            if let button = statusItem.button {
                button.image = NSImage(named: NSImage.Name("StatusBarButtonImageFilled"))
            }
        }
    }
    
    @objc func disconnect(_ sender: Any?) {
        connector.disconnectAirPods {
            if let button = statusItem.button {
                button.image = NSImage(named: NSImage.Name("StatusBarButtonImageNotFilled"))
            }
        }
    }
    
    @objc func openSettings(_ sender: Any?) {
        openWindow()
        
        if popUpButton.numberOfItems <= 0 {
            populatePopUpButtonItems()
        }
    }
    
    @objc func quitApp(_ sender: Any?) {
        NSApp.terminate(self)
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Connect AirPods", action: #selector(connect(_:)), keyEquivalent: "c"))
        menu.addItem(NSMenuItem(title: "Disconnect AirPods", action: #selector(disconnect(_:)), keyEquivalent: "d"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
}

