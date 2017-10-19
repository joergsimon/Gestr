//
//  Utils.swift
//  Gestr
//
//  Created by Andrea Simon on 15.10.17.
//  Copyright © 2017 Joerg Simon. All rights reserved.
//

import Foundation

func primitiveToData<T>(elem : T) -> Data {
    var e = elem
    return Data(buffer: UnsafeBufferPointer(start: &e, count: 1))
}
