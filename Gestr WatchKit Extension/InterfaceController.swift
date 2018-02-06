//
//  InterfaceController.swift
//  Gestr WatchKit Extension
//
//  Created by Andrea Simon on 15.10.17.
//  Copyright © 2017 Joerg Simon. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

func makeLine(_ data:[Double])->String {
    let d = data.flatMap {String(format:"%.2f",$0) }.joined(separator: ",")
    let dline = "(\(d))"
    return dline
}

class InterfaceController: WKInterfaceController, RecordingManagerDelegate {
    @IBOutlet var headingLabel: WKInterfaceLabel!
    @IBOutlet var gravityLabel: WKInterfaceLabel!
    @IBOutlet var attituteLabel: WKInterfaceLabel!
    
    @IBAction func stop() {
        recordingManager.stop()
    }
    
    @IBAction func start() {
        recordingManager.start()
    }
    
    let recordingManager = RecordingManager()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        recordingManager.delegate = self
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        WKExtension.shared().isFrontmostTimeoutExtended = true
        WKInterfaceDevice.current().play(.start)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func manager(_ manager: RecordingManager, received data: CMDeviceMotion) {
        let gline = makeLine(data.gravity.vector())
        let aline = makeLine(data.attitude.vector())
        DispatchQueue.main.async {
            self.headingLabel.setText(String(data.heading))
            self.gravityLabel.setText(gline)
            self.attituteLabel.setText(aline)
        }
        
    }
}
