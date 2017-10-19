//
//  DeviceMotionExtension.swift
//  Gestr
//
//  Created by Andrea Simon on 15.10.17.
//  Copyright © 2017 Joerg Simon. All rights reserved.
//

// used Double/Float and so on to Data conversion:
// https://stackoverflow.com/questions/36812583/how-to-convert-a-float-value-to-byte-array-in-swift

import Foundation
import CoreMotion

extension CMDeviceMotion {
    
    func vector() -> [Double] {
        var vec = [Double]()
        vec.append(self.heading)
        vec.append(contentsOf: self.gravity.vector())
        vec.append(contentsOf: self.userAcceleration.vector())
        vec.append(contentsOf: self.magneticField.vector())
        vec.append(contentsOf: self.rotationRate.vector())
        vec.append(contentsOf: self.attitude.vector())
        return vec
    }
}

extension CMAttitude {
    
    func vector() -> [Double] {
        var vec = [Double]()
        vec.append(self.pitch)
        vec.append(self.roll)
        vec.append(self.yaw)
        return vec
    }
}

extension CMAcceleration {
    
    func vector() -> [Double] {
        var vec = [Double]()
        vec.append(self.x)
        vec.append(self.y)
        vec.append(self.z)
        return vec
    }
}

extension CMCalibratedMagneticField {
    func vector() -> [Double] {
        var vec = [Double]()
        vec.append(self.field.x)
        vec.append(self.field.y)
        vec.append(self.field.z)
        return vec
    }
}

extension CMRotationRate {
    func vector() -> [Double] {
        var vec = [Double]()
        vec.append(self.x)
        vec.append(self.y)
        vec.append(self.z)
        return vec
    }
}
