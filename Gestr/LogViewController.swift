//
//  ViewController.swift
//  Gestr
//
//  Created by Andrea Simon on 15.10.17.
//  Copyright © 2017 Joerg Simon. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, RecorderDelegate {
    
    let recorder = Recorder()

    @IBOutlet weak var logView: UITextView!
    @IBOutlet weak var cusomLabel: UITextField!
    @IBOutlet weak var startNextButton: UIButton!
    @IBOutlet weak var stopNextButton: UIButton!
    @IBOutlet weak var startPrevButton: UIButton!
    @IBOutlet weak var stopPrevButton: UIButton!
    @IBOutlet weak var startInitButton: UIButton!
    @IBOutlet weak var stopInitButton: UIButton!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var stopPauseButton: UIButton!
    @IBOutlet weak var startCustomLabelButton: UIButton!
    @IBOutlet weak var stopCustomLabelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logButtonPressed(_ sender: UIButton) {
        if sender == startNextButton {
            recorder.startAnnotation(with: "next")
        }
        else if sender == stopNextButton {
            recorder.stopAnnotation()
        }
        else if sender == startPrevButton {
            recorder.startAnnotation(with: "prev")
        }
        else if sender == stopPrevButton {
            recorder.stopAnnotation()
        }
        else if sender == startInitButton {
            recorder.startAnnotation(with: "init")
        }
        else if sender == stopInitButton {
            recorder.stopAnnotation()
        }
        else if sender == startPauseButton {
            recorder.startAnnotation(with: "pause")
        }
        else if sender == stopPauseButton {
            recorder.stopAnnotation()
        }
        else if sender == startCustomLabelButton {
            guard let lbl = cusomLabel.text else {
                print("error, no cursom label to annotate")
                return
            }
            recorder.startAnnotation(with: lbl)
        }
        else if sender == stopCustomLabelButton {
            recorder.stopAnnotation()
        }
    }
    
    @IBAction func share(_ sender: Any) {
        let tmpcsvName = "tmp.csv"
        if Utils.exists(file: tmpcsvName) {
            try! Utils.delete(file: tmpcsvName)
        }
        let path = try! Utils.save(data: recorder.getCSV(), to: tmpcsvName)
        let fileURL = URL(fileURLWithPath: path)
        let objectsToShare = [fileURL]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func recorder(_ recorder: Recorder, received d: LabeledMotionData) {
        self.logView.text = recorder.getCSV()
    }
}

