//
//  Math.swift
//  Gestr
//
//  Created by Andrea Simon on 24.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation
import Accelerate
public enum MyError : Error {
    case RuntimeError(String)
}

public func abs(real:Double, img:Double) -> Double {
    return sqrt(pow(real, 2.0) + pow(img, 2.0))
}

public func abs(realArray:[Double], imgArray:[Double]) -> [Double] {
    let a = zip(realArray, imgArray).flatMap { abs(real: $0.0, img: $0.1) }
    return a
}

public func pow(_ array: [Double], _ to:Double) -> [Double] {
    let p = array.map() { pow($0, to) }
    return p
}

public func fftfreq(n:Int, d:Double) -> [Double] {
    let val = 1.0/(Double(n)*d)
    let N = n/2 + 1
    let results : [Double] = Array<Int>(0..<N).flatMap { Double($0) }
    return results.flatMap() { $0 * val }
}

public extension Array where Element == Double {
    
    static var fftSetups : [Int : vDSP_DFT_SetupD] = [Int : vDSP_DFT_SetupD]()
    
    static func getSetup(for length: Int) -> vDSP_DFT_SetupD? {
        if let s = Array<Double>.fftSetups[length] {
            return s
        }
        else {
            let s = vDSP_DFT_zop_CreateSetupD(nil, vDSP_Length(length), vDSP_DFT_Direction.FORWARD)
            Array<Double>.fftSetups[length] = s
            return s
        }
    }
    
    static func destroyAllSetups() {
        for (_, setup) in Array<Double>.fftSetups {
            vDSP_DFT_DestroySetupD(setup)
        }
    }
    
    public func nanmin() -> Double? {
        guard let r = self.min() else {
            return nil
        }
        if r.isNaN {
            return removeNan().nanmin();
        }
        else {
            return r
        }
    }
    
    public func nanmax() -> Double? {
        guard let r = self.max() else {
            return nil
        }
        if r.isNaN {
            return removeNan().nanmax();
        }
        else {
            return r
        }
    }
    
    public func removeNan() -> [Double] {
        let splits = self.split { (d) -> Bool in
            return d.isNaN
        }
        return splits.reduce([Double]()) { (r, s) -> [Double] in
            return r + Array<Double>(s)
        }
    }
    
    public func median() -> Double {
        return quantile(at: 0.5)
    }
    
    public func quantile(at percent: Double) -> Double {
        var pos = Double(self.count - 1) * percent
        if pos.truncatingRemainder(dividingBy: 1) < 0.00001 {
            return 0.5 * (self[Int(pos)] + self[Int(pos+1)])
        }
        else {
            pos = Swift.min(ceil(pos), Double(self.count - 1))
            return self[Int(pos)]
        }
    }
    
    public func sum() -> Double {
        return self.reduce(0.0) { $0 + ($1.isNaN ? 0.0 : $1) }
    }
    
    public func nanmean() -> Double {
        let s = self.sum()
        return s/Double(self.count)
    }
    
    public func moment(at m : Int) -> Double {
        let xmean = self.nanmean()
        let moment = self.reduce(0.0) { $0 + ($1.isNaN ? 0.0 : pow($1 - xmean, Double(m)))}
        return moment
    }
    
    public func nanvar() -> Double {
        let v = self.moment(at: 2)
        return v
    }
    
    public func nanstd() -> Double {
        let v = self.nanvar()
        return sqrt(v/Double(self.count))
    }
    
    public func skew() -> Double { // sample skewness used https://en.wikipedia.org/wiki/Skewness
        let m2 = self.moment(at: 2)
        let m3 = self.moment(at: 3)
        let n = Double(self.count)
        return sqrt((n - 1.0) * n) / (n - 2.0) * m3 / pow(m2,1.5)
    }
    
    public func kurtosis() -> Double {
        let n = Double(self.count)
        let m2 = self.moment(at: 2) / n
        let m4 = self.moment(at: 4) / n
        
        return (m4 / pow(m2, 2.0)) - 3.0
    }
    
    public func mode() -> Double {
        let srt = self.sorted()
        var cnt = 0
        var mode = srt[0]
        var e_cnt = 0
        var current = mode
        for e in srt {
            if e == current {
                e_cnt += 1
            }
            else {
                current = e
                e_cnt = 0
            }
            if e_cnt > cnt {
                cnt = e_cnt
                mode = e
            }
        }
        return mode
    }
    
    public func fft() throws -> ([Double], [Double]) {
        let log2N = vDSP_Length(log2f(Float(self.count)))
        let fftN = Int(1 << log2N)
        
        let realPart = [Double](self[0..<fftN])
        let imgPart = [Double](repeating: 0.0, count: fftN)
        
        var resRealPart = [Double](repeating: 0.0, count: fftN)
        var resImgPart = [Double](repeating: 0.0, count: fftN)
        
        guard let setup = Array<Double>.getSetup(for: fftN) else {
            print("error could not create setup for fft!");
            throw MyError.RuntimeError("error could not create setup for fft!")
        }
        vDSP_DFT_ExecuteD(setup, realPart, imgPart, &resRealPart, &resImgPart)
        
        return (resRealPart, resImgPart)
    }
    
    public func entropy() -> Double {
        var logs = [Double](repeating: 0.0, count: self.count)
        vvlog(&logs, self, [Int32(self.count)])
        let pointEntropy = zip(self, logs).map() { $0.0 * $0.1 }
        let entr = pointEntropy.sum()
        return entr
    }
}

public func *(lhs: [Double], rhs: [Double]) -> [Double] {
    let r = zip(lhs, rhs).map() { $0.0 * $0.1 }
    return r
}

public func /(lhs: [Double], rhs: [Double]) -> [Double] {
    let r = zip(lhs, rhs).map() { $0.0 / $0.1 }
    return r
}

public func /(lhs: [Double], rhs: Double) -> [Double] {
    let r = lhs.map() { $0 / rhs }
    return r
}

