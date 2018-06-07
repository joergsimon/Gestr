//
//  TransformToFeatures.swift
//  Gestr
//
//  Created by Andrea Simon on 01.03.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation
import Accelerate

func transform(_ array: [Double]) -> [Double] {
    let log2N = vDSP_Length(log2f(Float(array.count)))
    let fftN = Int(1 << log2N)
    
    let min = array.nanmin()!
    let max = array.nanmax()!
    let range = max - min
    let mean = array.nanmean()
    let std = array.nanstd()
    let vr = array.nanvar()/Double(array.count)
    let sorted = array.sorted()
    let median = sorted.median()
    let q25 = sorted.quantile(at: 0.25)
    let q75 = sorted.quantile(at: 0.75)
    let skew = array.skew()
    let kurtosis = array.kurtosis()
    let mode = array.mode()
    let fft = try! array.fft()
    let magintutes = abs(realArray: fft.0, imgArray: fft.1)
    let freq = fftfreq(n: fftN, d: (1.0/58.0))
    let spectral_centroid = (magintutes*freq).sum()/magintutes.sum()
    let psd = pow(magintutes, 2.0)/freq
    let psdsum = psd.sum()
    let psdnorm = psd/psdsum
    let spectral_entropy = psdnorm.entropy()
    let m = magintutes
    let frq_5sum = m[0] + m[1] + m[2] + m[3] + m[4] //[Double](magintutes[0..<5]).sum()
    let bandwidth = freq.nanmax()! - freq.nanmin()!
    
    return [mean, std, min, q25, median, q75, max, range, vr, skew, kurtosis, mode, spectral_centroid, spectral_entropy, m[0], m[1], m[2], m[3], m[4], frq_5sum, bandwidth]
}
