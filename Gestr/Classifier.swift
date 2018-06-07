//
//  Classifier.swift
//  Gestr
//
//  Created by Andrea Simon on 07.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation
import CoreML

protocol ClassiferDelegate {
    func classifier(_ clf: Classifier, predicted lbl: Int64)
}

class Classifier : SessionDelegate {
    let session = Session()
    var data = [MotionData]()
    var delegate : ClassiferDelegate?
    let model = linsvc()
    
    init() {
        session.delegate = self
    }
    
    func start() {
        session.start { (sucess) in
            // TODO
        }
    }
    
    func session(_ session: Session, received d: MotionData) {
        data.append(d)
        if data.count >= 150 && data.count % 50 == 0 {
            let subset : [MotionData] = Array(data[(data.count-150)...])
            let f = features(from: subset)
            guard let matrix = try? MLMultiArray(shape:[1,128], dataType:MLMultiArrayDataType.double) else {
                fatalError("Unexpected runtime error. MLMultiArray")
            }
            for (idx, elem) in f.enumerated() {
                matrix[idx] = NSNumber(value: elem)
            }
            let input = linsvcInput(input: matrix)
            let res = try! model.prediction(input: input)
            print(res)
            delegate?.classifier(self, predicted: res.classLabel)
        }
    }
    
    func features(from mdata : [MotionData]) -> [Double] {
        var result = [Double]()
        for i in 0...15 {
            result.append(contentsOf: features(from: mdata, at: i))
        }
        let f = MinMaxScaler().scale(data: result)
        return f
    }
    
    func features(from mdata : [MotionData], at column : Int) -> [Double] {
        var vector = [Double]()
//        var result = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        for d in mdata {
            vector.append(d.readings[column])
        }
        let result = transform(vector)
//        result[0] = Double(vector.count)
//        let sum = vector.reduce(0.0) { $0 + $1 }
//        let mean = sum / result[0]
//        result[1] = mean
//        let xminav = vector.map { pow($0 - mean, 2.0) }
//        let vsum = xminav.reduce(0.0) { $0 + $1 }
//        let varsq = vsum / result[0]
//        let variance = varsq.squareRoot()
//        result[2] = variance
//        result[3] = vector.min()!
//        let sorted = vector.sorted()
//        result[4] = quantile(from: sorted, at: 0.25)
//        result[5] = quantile(from: sorted, at: 0.5)
//        result[6] = quantile(from: sorted, at: 0.7)
//        result[7] = vector.max()!
        // check results:
        for i in 0..<result.count {
            if result[i].isNaN {
                print("error in feature processing, feature \(i) at column \(column) is NaN")
            }
        }
        return result
    }
    
    func quantile(from data : [Double], at percent: Double) -> Double {
        var pos = Double(data.count - 1) * percent
        if pos.truncatingRemainder(dividingBy: 1) < 0.00001 {
            return 0.5 * (data[Int(pos)] + data[Int(pos+1)])
        }
        else {
            pos = max(ceil(pos), Double(data.count - 1))
            return data[Int(pos)]
        }
    }
    
}
