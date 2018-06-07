//
//  RecordingManager.swift
//  Gestr WatchKit Extension
//
//  Created by Andrea Simon on 05.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation
import CoreMotion

protocol RecordingManagerDelegate {
    func manager(_ manager: RecordingManager, received data: CMDeviceMotion)
}

class RecordingManager : WorkoutManagerDelegate {
    let workoutManager = WorkoutManager()
    let parentConnector = ParentConnector()
    var delegate : RecordingManagerDelegate?
    var isStarted = false
    var originalDate: Date? = nil
    
    init() {
        workoutManager.delegate = self
    }
    
    func start() {
        isStarted = true
        workoutManager.startWorkout()
    }
    
    func stop() {
        workoutManager.stopWorkout()
        isStarted = false
        originalDate = nil
    }
    
    func manager(_ manager: WorkoutManager, received data: CMDeviceMotion) {
        if originalDate == nil {
            originalDate = Date(timeIntervalSinceNow: -data.timestamp)
        }
        let timestamp = Date(timeInterval: data.timestamp, since: originalDate!).timeIntervalSince1970
        let readings = data.vector()
        let d = MotionData(timestamp: timestamp, readings: readings)
        parentConnector.send(data: d)
        delegate?.manager(self, received: data)
    }
}
