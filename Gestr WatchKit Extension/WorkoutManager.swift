//
//  WorkoutManager.swift
//  Gestr WatchKit Extension
//
//  Created by Andrea Simon on 05.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation
import HealthKit
import CoreMotion

/*
 
 We need a workout mode to have the tracking on all the time...
 
 */

protocol WorkoutManagerDelegate: class {
    func manager(_ manager: WorkoutManager, received data: CMDeviceMotion)
}

class WorkoutManager: MotionManagerDelegate {
    
    let motionManager = MotionManager()
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var delegate: WorkoutManagerDelegate?
    
    init() {
        motionManager.delegate = self
    }
    
    func manager(_ manager: MotionManager, received data: CMDeviceMotion) {
        delegate?.manager(self, received: data)
    }
    
    func startWorkout() {
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .unknown
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        // Start the workout session and device motion updates.
        healthStore.start(session!)
        motionManager.startUpdates()
    }
    
    func stopWorkout() {
        // If we have already stopped the workout, then do nothing.
        if (session == nil) {
            return
        }
        
        // Stop the device motion updates and workout session.
        motionManager.stopUpdates()
        healthStore.end(session!)
        
        // Clear the workout session.
        session = nil
    }
}
