//
//  Connector.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Foundation

class Connector: NSObject, DeviceComponent {
    
    var radius: Float = 0.0
    var rotation: Float = 0.0
    
    var topComponent: DeviceComponent?
    var bottomComponent: DeviceComponent?
    
    // Tests for connection existence
    var hasTopComponent: Bool {
        return topComponent != nil
    }
    
    var hasBottomComponent: Bool {
        return bottomComponent != nil
    }

    // Initialize with a certain radius
    init(radius: Float) {
		self.radius = radius
    }

    convenience init(radius: Float, top: DeviceComponent, bottom: DeviceComponent) {
        self.init(radius: radius)
        
        // If connecting gears, make sure the gears are aware
        (top as? Gear)?.addNeighbor(self)
        (bottom as? Gear)?.addNeighbor(self)
        
        setConnections(top, bottom: bottom)
    }

    // Convenience method for setting connections easily
    func setConnections(top: DeviceComponent, bottom: DeviceComponent) {
        topComponent = top
        bottomComponent = bottom
    }

    // Protocol Methods:
    func getRotation() -> Float { return rotation }
    
    func getRadius() -> Float { return radius }

    func rotate(arcAngle: Float) {
        rotation += arcAngle
        
        updateTopComponentRotation(arcAngle)
        updateBottomComponentRotation(arcAngle)
    }
    
    func updateRotation(arcAngle: Float, fromSource source: DeviceComponent) {
        rotation += arcAngle
        
        if let topComponent = topComponent {
            if source != topComponent {
                updateTopComponentRotation(arcAngle)
            }
        }
        
        if let bottomComponent = bottomComponent {
            if source != bottomComponent {
                updateBottomComponentRotation(arcAngle)
            }
        }
    }

    // Updates connection rotations, if they exist
    func updateTopComponentRotation(arcAngle: Float) {
        topComponent?.updateRotation(arcAngle, fromSource: self)
    }

    func updateBottomComponentRotation(arcAngle: Float) {
        bottomComponent?.updateRotation(arcAngle, fromSource: self)
    }

}
