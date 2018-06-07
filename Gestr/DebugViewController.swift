//
//  DebugViewController.swift
//  Gestr
//
//  Created by Andrea Simon on 07.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController, ClassiferDelegate {
    
    let classifier = Classifier()
    let lbls = ["none", "thumbs up", "thumbs down", "next", "prev"]
    var lastlbl = Int64(0)
    
    @IBOutlet weak var logView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classifier.delegate = self
        classifier.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func classifier(_ clf: Classifier, predicted lbl: Int64) {
        if lastlbl == lbl {
            return
        }
        lastlbl = lbl
        DispatchQueue.main.async {
            let oldtxt = self.logView.text ?? ""
            self.logView.text = "\(oldtxt)\n\(self.lbls[Int(lbl)])"
        }
    }
}


