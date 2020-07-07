//
//  ConnectorInfo.swift
//  AntikytheraOpenGLPrototype
//
//  Created by Juan J. Collas on 7/6/2020.
//

import Foundation

struct ConnectorInfo: Codable {

    enum CodingKeys: String, CodingKey {
        case name
        case radius
        case topGear
        case bottomGear
        case connectionType = "connector-type"
    }

    var name: String
    var radius: Float
    var topGear: String
    var bottomGear: String
    var connectionType: String
}
