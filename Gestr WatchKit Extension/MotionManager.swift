//
//  MotionManager.swift
//  Gestr WatchKit Extension
//
//  Created by Andrea Simon on 05.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation
import CoreMotion
import WatchKit

protocol MotionManagerDelegate: class {
    func manager(_ manager: MotionManager, received data: CMDeviceMotion)
}

class MotionManager {
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
    let sampleInterval = 1.0 / 50
    
    var delegate : MotionManagerDelegate?
    
    init() {
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
    }
    
    func startUpdates() {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = sampleInterval
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }
//            print("debug: got device motion...")
            
            if let dM = deviceMotion {
                self.processDeviceMotion(dM)
            }
        }
//        motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
//            if error != nil {
//                print("Encountered error: \(error!)")
//            }
//            print("debug: got device motion...")
//
//            if let dM = deviceMotion {
//                self.processDeviceMotion(dM)
//            }
//        }
    }
    
    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        delegate?.manager(self, received: deviceMotion)
    }
}
