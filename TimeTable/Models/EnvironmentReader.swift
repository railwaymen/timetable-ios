//
//  EnvironmentReader.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 26/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol EnvironmentReaderType: class {
    func getString(forKey key: EnvironmentReader.Key) -> String?
    func getURL(forKey key: EnvironmentReader.Key) -> URL?
}

class EnvironmentReader {}

// MARK: - Structures
extension EnvironmentReader {
    enum Key: String {
        #if TEST
        case serverURL
        case screenToTest
        #else
        case none
        #endif
    }
}

// MARK: - EnvironmentReaderType
extension EnvironmentReader: EnvironmentReaderType {
    func getString(forKey key: EnvironmentReader.Key) -> String? {
        return ProcessInfo.processInfo.environment[key.rawValue]
    }
    
    func getURL(forKey key: EnvironmentReader.Key) -> URL? {
        guard let string = getString(forKey: key) else { return nil }
        return URL(string: string)
    }
}
