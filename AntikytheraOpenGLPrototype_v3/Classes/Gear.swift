//
//  Gear.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Foundation

class Gear: NSObject, DeviceComponent {
    var radius: Float = 0.0
    var rotation: Float = 0.0
    var toothCount = 0
    
    var neighbors: [DeviceComponent] = []

    // Initialize with a specific tooth count. Radius is calculated from tooth count.
    init(teeth: Int) {
        toothCount = teeth
        radius = Float(teeth)/Float(2.0*M_PI)
        rotation = 0.0
    }
    
    init(teeth: Int, radiusScale scale: Float) {
		toothCount = teeth
		radius = (Float(teeth)/Float(2.0*M_PI))*scale
		rotation = 0.0
    }

    // Get tooth count
    func getToothCount() -> Int { return toothCount }

    // Add neighbor component to list of neighbors
    func addNeighbor(neighbor: DeviceComponent) {
        neighbors.append(neighbor)
    }

    // Protocol Methods:
    func getRotation() -> Float { return rotation }

    func getRadius() -> Float { return radius }

    func rotate(arcAngle: Float) {
        rotation += arcAngle
        
        updateNeighborRotations(arcAngle, except: nil)
    }
    
    func updateRotation(var arcAngle: Float, fromSource source: DeviceComponent) {
        
        if source is Gear {
            // inverse ratio because it is initially relative to other gear
            let ratio = source.getRadius()/radius
            arcAngle = -1.0*arcAngle*ratio
        }
        
        rotation += arcAngle
        updateNeighborRotations(arcAngle, except: source)
    }

    // Update neighbor rotations
    func updateNeighborRotations(arcAngle: Float, except source: DeviceComponent?) {
        
        for component in neighbors {
            if source == nil || component != source! {
                component.updateRotation(arcAngle, fromSource: self)
            }
        }
    }

}
