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

class InterfaceController: WKInterfaceController {
    @IBOutlet var headingLabel: WKInterfaceLabel!
    @IBOutlet var gravityLabel: WKInterfaceLabel!
    @IBOutlet var attituteLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
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

}
