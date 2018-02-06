//
//  PartentConnector.swift
//  Gestr WatchKit Extension
//
//  Created by Andrea Simon on 05.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation
import WatchConnectivity

class ParentConnector: NSObject, WCSessionDelegate {
    var wcSession: WCSession?
    var data = [MotionData]()
    
    func send(data d: MotionData) {
        if let session = wcSession {
            if session.isReachable {
                session.sendMessage(["data": d], replyHandler: nil)
            }
        } else {
            WCSession.default.delegate = self
            WCSession.default.activate()
            data.append(d)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if activationState == .activated {
            wcSession = session
            sendPending()
        }
    }
    
    private func sendPending() {
        if let session = wcSession, session.isReachable {
            for d in data {
                session.sendMessage(["data": d], replyHandler: nil)
            }
            data.removeAll()
        }
    }
}
