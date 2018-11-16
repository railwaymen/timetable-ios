//
//  ServerConfiguration.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct ServerConfiguration {
    var host: URL?
    var shouldRememberHost: Bool
}

extension ServerConfiguration: Equatable {
    static func == (lhs: ServerConfiguration, rhs: ServerConfiguration) -> Bool {
        return lhs.host == rhs.host && lhs.shouldRememberHost == rhs.shouldRememberHost
    }
}
