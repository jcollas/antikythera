//
//  Gear.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Foundation

class Placement {
    
//    { "forComponent" : "gB0", "positionType" : "fixed",          "x" : 0.0, "y": 0.0, "z": 40.0 },
//    { "forComponent" : "gB1", "positionType" : "verticalOffset", "toGear": "gB0", "offset" : -5.0 },
//    { "forComponent" : "gA1", "positionType" : "angledRelative", "toGear": "gB1", "radians" : 3.1415925 },

    init(dict: [String:AnyObject]) {
        
    }
}

class Gear: NSObject, DeviceComponent {
    var radius: Float = 0.0
    var rotation: Float = 0.0
    var name = ""
    
    var toothCount = 0
    
    var neighbors: [DeviceComponent] = []
    var linkedTo = [String]()
    var placementInfo: PlacementInfo

    // Initialize with a specific tooth count. Radius is calculated from tooth count.
    init(_ info: GearInfo) {
        self.name = info.name
        self.toothCount = info.teeth

        let teeth = Float(truncating: NSNumber(value: info.teeth))
        if let scale = info.radiusScale {
            self.radius = (teeth / (2.0 * .pi)) * scale
        } else {
            self.radius = teeth / (2.0 * .pi)
        }

        self.placementInfo = info.placement

        if let linkedTo = info.linkedTo {
            self.linkedTo.append(contentsOf: linkedTo)
        }

        self.rotation = 0.0
    }

    // Add neighbor component to list of neighbors
    func addNeighbor(_ neighbor: DeviceComponent) {
        neighbors.append(neighbor)
    }

    // Protocol Methods:

    func rotate(_ arcAngle: Float) {
        rotation += arcAngle
        
        updateNeighborRotations(arcAngle, except: nil)
    }
    
    func updateRotation(_ arcAngle: Float, fromSource source: DeviceComponent) {
        var arcAngle = arcAngle
        
        if source is Gear {
            // inverse ratio because it is initially relative to other gear
            let ratio = source.radius/radius
            arcAngle = -1.0*arcAngle*ratio
        }
        
        rotation += arcAngle
        updateNeighborRotations(arcAngle, except: source)
    }

    // Update neighbor rotations
    func updateNeighborRotations(_ arcAngle: Float, except source: DeviceComponent?) {
        
        for component in neighbors {
            if source == nil || component != source! {
                component.updateRotation(arcAngle, fromSource: self)
            }
        }
    }

}
