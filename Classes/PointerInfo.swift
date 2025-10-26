//
//  PointerInfo.swift
//  Antikythera
//
//  Created by Juan J. Collas on 7/6/2020.
//

import Foundation

struct PointerInfo: Decodable {

    var name: String
    var pointerKind: String
    var onGear: String
    var rotatesToPointer: String?
    var shaftLength: Float
    var shaftRadius: Float
    var pointerLength: Float
    var pointerWidth: Float
}
