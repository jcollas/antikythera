//
//  MechanismInfo.swift
//  Antikythera
//
//  Created by Juan J. Collas on 7/7/2020.
//

import Foundation

struct MechanismInfo: Decodable {
    var gears: [GearInfo]
    var connectors: [ConnectorInfo]
    var pointers: [PointerInfo]
}
