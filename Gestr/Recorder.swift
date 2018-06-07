//
//  Recorder.swift
//  Gestr
//
//  Created by Andrea Simon on 05.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation

struct Label {
    let start : TimeInterval
    let end : TimeInterval
    let label : String
    
    func csvLine() -> String {
        let line = "\(start),\(end),\(label)"
        return line
    }
}

protocol RecorderDelegate {
    func recorder(_ recorder: Recorder, received d: MotionData)
}

class Recorder : SessionDelegate {
    let defaultAnnotation = ("none", 0.0)
    let session = Session()
    var data = [MotionData]()
    var labels = [Label]()
    var currentAnnotation = ("none", 0.0)
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
        data.append(d)
        delegate?.recorder(self, received: d)
    }
    
    func startAnnotation(with label : String) {
        if (currentAnnotation != defaultAnnotation && currentAnnotation.0 != label) {
            stopAnnotation()
        }
        currentAnnotation = (label, Date().timeIntervalSince1970)
    }
    
    func stopAnnotation() {
        if (currentAnnotation != defaultAnnotation) {
            labels.append(Label(start: currentAnnotation.1, end: Date().timeIntervalSince1970, label: currentAnnotation.0))
            currentAnnotation = defaultAnnotation
        }
    }
    
    func getDataCSV() -> String {
        let d = data
        let csv = d.flatMap { $0.csvLine() }.joined(separator: "\n")
        return csv
    }
    
    func getLabelsCSV() -> String {
        let l = labels
        let csv = l.flatMap { $0.csvLine() }.joined(separator: "\n")
        return csv
    }
    
    func clear() {
        stopAnnotation()
        data.removeAll()
    }
    
}
