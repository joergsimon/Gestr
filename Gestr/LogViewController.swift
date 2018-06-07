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
    var updateLog = false
    
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
        recorder.delegate = self
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
        let dataURL = create(tmpName: "data-tmp.csv", with: recorder.getDataCSV())
        let labelsURL = create(tmpName: "labels-tmp.csv", with: recorder.getLabelsCSV())
        let objectsToShare = [dataURL, labelsURL]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func clear(_ sender: Any) {
        recorder.clear()
        updateLog = true
        logView.text = recorder.getDataCSV()
        updateLog = false
    }
    
    func create(tmpName : String, with data : String) -> URL {
        if Utils.exists(file: tmpName) {
            try! Utils.delete(file: tmpName)
        }
        let path = try! Utils.save(data: data, to: tmpName)
        let fileURL = URL(fileURLWithPath: path)
        return fileURL
    }
    
    func recorder(_ recorder: Recorder, received d: MotionData) {
        if updateLog {
            return
        }
        updateLog = true
        DispatchQueue.main.async {
            self.logView.text = recorder.getDataCSV()
            self.updateLog = false
        }
    }
}

