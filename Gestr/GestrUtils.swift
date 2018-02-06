//
//  Utils.swift
//  Gestr
//
//  Created by Andrea Simon on 06.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation

enum GestErrors : Error {
    case illegalStateError
}

class Utils {
    
    static func exists(file : String) -> Bool {
        let filename : String = Utils.getDocumentsDirectoryUrl().appendingPathComponent(file).absoluteString
        return FileManager.default.fileExists(atPath: filename)
    }
    
    static func delete(file : String) throws {
        let filename : String = Utils.getDocumentsDirectoryUrl().appendingPathComponent(file).absoluteString
        try FileManager.default.removeItem(atPath: filename)
    }
    
    static func save(data : String, to file : String) throws -> String {
        let filename = Utils.getDocumentsDirectoryUrl().appendingPathComponent(file)
        try data.write(to: filename, atomically: true, encoding: .utf8)
        return filename.absoluteString
    }
    
    static func getDocumentsDirectoryUrl() -> URL {
        return URL(fileURLWithPath: getDocumentsDirectory())
    }
    
    static func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
