//
//  Recorder.swift
//  Gestr
//
//  Created by Andrea Simon on 05.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation

struct LabeledMotionData {
    let timestamp : TimeInterval
    let readings : [Double]
    let label : String
    
    func csvLine() -> String {
        let d = readings.flatMap {String($0)}.joined(separator: ",")
        let line = "\(timestamp),\(d),\(label)"
        return line
    }
}

protocol RecorderDelegate {
    func recorder(_ recorder: Recorder, received d: LabeledMotionData)
}

class Recorder : SessionDelegate {
    let defaultAnnotation = "none"
    let session = Session()
    var data = [LabeledMotionData]()
    var currentAnnotation = "none"
    var delegate : RecorderDelegate?
    
    init() {
        session.delegate = self
    }
    
    func start() {
        session.start { (sucess) in
            // TODO
        }
    }
    
    func session(_ session: Session, received d: MotionData) {
        let ld = LabeledMotionData(timestamp: d.timestamp, readings: d.readings, label: currentAnnotation)
        data.append(ld)
        delegate?.recorder(self, received: ld)
    }
    
    func startAnnotation(with label : String) {
        currentAnnotation = label
    }
    
    func stopAnnotation() {
        currentAnnotation = defaultAnnotation
    }
    
    func getCSV() -> String {
        let csv = data.flatMap { $0.csvLine() }.joined(separator: "\n")
        return csv
    }
    
    func clear() {
        stopAnnotation()
        data.removeAll()
    }
    
}
