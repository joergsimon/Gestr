//
//  File.swift
//  Gestr
//
//  Created by Andrea Simon on 05.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol SessionDelegate {
    func session(_ session: Session, received data : MotionData)
}

class Session: NSObject, WCSessionDelegate {
    
    var delegate : SessionDelegate?
    private var wcSessionActivationCompletion: ((WCSession) -> Void)?
    
    func start(completion: @escaping (Bool) -> Void) {
        getActiveWCSession { (s) in
            let sucess = s.activationState == .activated && s.isWatchAppInstalled
            completion(sucess)
        }
    }
    
    private func getActiveWCSession(completion: @escaping (WCSession) -> Void) {
        guard WCSession.isSupported() else {
            fatalError("watch connectivity session not supported")
        }
        
        let wcSession = WCSession.default
        wcSession.delegate = self
        
        switch wcSession.activationState {
        case .activated:
            completion(wcSession)
        case .inactive, .notActivated:
            wcSession.activate()
            wcSessionActivationCompletion = completion
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if activationState == .activated, let activationCompletion = wcSessionActivationCompletion {
            activationCompletion(session)
            wcSessionActivationCompletion = nil
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["Data"] as? MotionData {
            delegate?.session(self, received: data)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
}
