//
//  GearInfo.swift
//  Antikythera
//
//  Created by Juan J. Collas on 7/6/2020.
//

import Foundation

struct PlacementInfo: Decodable {
    var positionType: String
    var toGear: String?
    var x: Float?
    var y: Float?
    var z: Float?
    var offset: Float?
    var radians: Float?
}

struct GearInfo: Decodable {

    var name: String
    var teeth: Int
    var radiusScale: Float?
    var placement: PlacementInfo
    var linkedTo: [String]?
}
