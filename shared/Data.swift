//
//  File.swift
//  Gestr
//
//  Created by Andrea Simon on 05.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation

struct MotionData {
    let timestamp : TimeInterval
    let readings : [Double]
    
    func vector() -> [Double] {
        var res : [Double] = [timestamp]
        res.append(contentsOf: readings)
        return res
    }
    
    static func from(vector: [Double]) -> MotionData {
        let ts = vector[0]
        let readings : [Double] = Array(vector[1...])
        return MotionData(timestamp: ts, readings: readings)
    }
    
    func csvLine() -> String {
        let d = readings.flatMap {String($0)}.joined(separator: ",")
        let line = "\(timestamp),\(d)"
        return line
    }
}
