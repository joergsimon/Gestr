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
    var isSending = false
    
    func send(data d: MotionData) {
        data.append(d)
        if let session = wcSession {
            if session.isReachable && !isSending {
                send(with: session)
            }
        } else {
            WCSession.default.delegate = self
            WCSession.default.activate()
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
            send(with: session)
        }
    }
    
    private func send(with session: WCSession) {
        let d = data
        isSending = true
        data.removeAll()
        var payload = [[String:Any]]()//d.flatMap{ ["data": $0.vector()] }
        for e in d {
            let ed : [String : [Double]] = ["data": e.vector()]
            payload.append(ed)
        }
        let json = ["payload": payload]
        print(json)
        let jsondata = try! JSONSerialization.data(withJSONObject: json)
        session.sendMessageData(jsondata, replyHandler: { (data) in
            print("got reply:")
            print(data)
            self.isSending = false
        }) { (error) in
            print("error on sending!")
            print(error)
            self.isSending = false
        }
//        session.sendMessage(json, replyHandler: { (reply) in
//            print("got reply:")
//            print(reply)
//            self.isSending = false
//        }, errorHandler: { (error) in
//            print("error on sending!")
//            print(error)
//            self.isSending = false
//        })
    }
}
